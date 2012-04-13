module Mailchimp
  class User < Base
    class << self

      def subscribe(user, options = {:validate => true})
        assert_valid_options(user, options)

        run do
          return if options[:validate] && !user.subscribed?

          list_id = options[:list_id] || config[:list_id]
          parameters =  options[:parameters] || user.mailchimp_data

          begin
            logger.debug "[Mailchimp::User.subscribe] subscribe new email: #{user.email}"

            # http://apidocs.mailchimp.com/api/1.3/listsubscribe.func.php
            # params: string apikey, string id, string email_address, array merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome
            hominid.list_subscribe(list_id, user.email, parameters, 'html', false, true, true, false)
            user.subscribe! unless user.subscribed?

          rescue Hominid::APIError => error
            case(error.fault_code)
              when 214 # The new email address is already subscribed to this list and must be unsubscribed first.
                # skip
              when 220, 502 # email has been banned, Invalid Email Address
                # todo: move to event
                user.subscription_last_error = error.message
                user.error_subscribe!
              else
                raise error
            end
          end
        end
      end

      def subscribe_many(users, list_id = nil)
        run do
          list_id ||= config[:list_id]

          logger.debug "[Mailchimp::User.subscribe_many] unsubscribe emails: #{emails.join(", ")}"

          # http://apidocs.mailchimp.com/api/1.3/listbatchsubscribe.func.php
          # params: string apikey, string id, array batch, boolean double_optin, boolean update_existing, boolean replace_interests
          hominid.list_batch_subscribe(list_id, users.map(&:mailchimp_data), false, true, true)
        end
      end

      def update(user, options = {:validate => true})
        assert_valid_options(user, options)

        run do
          return if options[:validate] && !user.subscribed?
          list_id = options[:list_id] || config[:list_id]
          parameters =  options[:parameters] || user.mailchimp_data

          begin
            logger.debug "[Mailchimp::User.update] update '#{user.email}' info"

            # http://apidocs.mailchimp.com/api/1.3/listupdatemember.func.php
            # listUpdateMember(string apikey, string id, string email_address, array merge_vars, string email_type, boolean replace_interests)
            hominid.listUpdateMember(list_id, user.email, parameters, "html", true)
          rescue Hominid::APIError => error
            case(error.fault_code)
              # @note temporary disable
              #when 215, 232 # email address does not belong to this list, There is no record in the database
              #  subscribe(user, parameters, list_id)
              when 232 #  There is no record in the database
                subscribe(user, parameters: parameters, list_id: list_id, validate: false)
              when 270 # is not a valid Interest Group for the list
                raise error
              else
                raise error
            end
          end
        end
      end

      def update_unsubscribes(list_id = nil, campaign_ids = nil)
        unsubscribes(list_id, campaign_ids) do |unsubscribe|
          emails = unsubscribe["data"].collect{ |e| e["email"] }
          logger.debug "[Mailchimp::User.update_unsubscribes] update unsubscribes emails: #{emails.join(", ")}"

          emails.each do |email|
            user = User.find_by_email(email)
            user.unsubscribe! if user && user.subscribed?
          end
        end
      end

      def update_all
        [].tap do |errors|
          User.subscribers.find_in_batches(batch_size: 50) do |users|
            users.each do |user|
              unless update(user)
                errors << user.id
              end
            end
          end
        end
      end

      def unsubscribe(email, options = {:validate => true})
        run do
          list_id = options[:list_id] || config[:list_id]

          begin
            logger.debug "[Mailchimp::User.unsubscribe] unsubscribe '#{email}' email"

            # http://apidocs.mailchimp.com/api/1.3/listunsubscribe.func.php
            # listUnsubscribe(string apikey, string id, string email_address, boolean delete_member, boolean send_goodbye, boolean send_notify)
            hominid.list_unsubscribe(list_id, email, false, false, false)

            # todo: move this to events
            user = ::User.find_by_email(email)
            user.unsubscribe! if user && !user.unsubscribed?
          rescue Hominid::APIError => error
            case(error.fault_code)
              when 215, 232 # email address does not belong to this list
                            #skip this errors
              else
                raise error
            end
          end
        end
      end

      protected
      def assert_valid_options(user, options)
        raise ArgumentError, "first argument should be a User instance" unless user.is_a?(::User)

      end
    end
  end
end