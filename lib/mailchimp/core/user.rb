# -*- encoding: utf-8 -*-

# todo: move run and default options to another layer
module Mailchimp
  class User < Base

    class << self

      def subscribe(user, options = {})
        default_options(options)
        run do
          user_list = user.mailchimp_list(options)

          #return unless user_list.subscribed?

          begin
            logger.debug "[Mailchimp::User.subscribe] subscribe new email: #{user.email}"

            # http://apidocs.mailchimp.com/api/1.3/listsubscribe.func.php
            # params: string apikey, string id, string email_address, array merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome
            hominid.list_subscribe(user_list.id, user.email, user_list.parameters, 'html', options[:double_optin], false, true, false)

            #user_list.mark_subscribed!

          rescue Hominid::APIError => error
            logger.error "[Mailchimp::User.subscribe] error subscribe: #{user.email}. #{error}"
            case(error.fault_code)
              when 214 # The new email address is already subscribed to this list and must be unsubscribed first.
                # skip this error
              when 220, 502 # email has been banned, Invalid Email Address
                # todo: bounce list
                user_list.subscription_error(error)
              else
                raise error
            end
          end
        end
      end

      def subscribe_many(users, list_name = nil)
        run do
          list = Mailchimp::List[list_name]

          logger.debug "[Mailchimp::User.subscribe_many] subscribe emails: #{users.collect(&:email).join(", ")}"

          # http://apidocs.mailchimp.com/api/1.3/listbatchsubscribe.func.php
          # params: string apikey, string id, array batch, boolean double_optin, boolean update_existing, boolean replace_interests
          hominid.list_batch_subscribe(list.id, users.map { |u| u.mailchimp_data(list) }, true, false, true)
        end
      end

      def update(user, options = {})
        default_options(options)

        run do
          user_list = user.mailchimp_list(options)

          #return unless user_list.subscribed?

          begin
            logger.debug "[Mailchimp::User.update] update '#{user.email}' info"

            # http://apidocs.mailchimp.com/api/1.3/listupdatemember.func.php
            # listUpdateMember(string apikey, string id, string email_address, array merge_vars, string email_type, boolean replace_interests)
            hominid.list_update_member(user_list.id, user.email, user_list.parameters, "html", true)

          rescue Hominid::APIError => error
            logger.error "[Mailchimp::User.update] error: #{user.email}. #{error}"
            case(error.fault_code)
              when 214
              #  # <214> The new email address "{email}" is already subscribed to this list and must be unsubscribed first.
              #  # skip this error
              when 232, 215
                # <215> The email address "{email}" does not belong to this list
                # List_NotSubscribed - the email address is not subscribed to the list (but may have been)
                #
                # <232> There is no record of "{email}" in the database
                # 232 = Email_NotExists - we have no record of the email address
                # subscribe(user, :parameters => user_list.parameters, :list => user_list.name, :validate => false)
              when 270 # is not a valid Interest Group for the list
                raise error
              else
                raise error
            end
          end
        end
      end

      # @params user with new email
      def change_email(user, old_email)
        new_email ||= user.email
        user.email = old_email
        update_all_lists(user, :parameters => {:email => new_email})
      end

      def update_all_lists(user, options = {})
        default_options(options)
        Mailchimp::List.lists.each do |list_name, list_params|
          update(user, options.merge(:list => list_name))
        end
      end

      def update_unsubscribes(list_name = nil, campaign_ids = nil)
        unsubscribes(list_name, campaign_ids) do |unsubscribe|
          emails = unsubscribe["data"].collect{ |e| e["email"] }
          logger.debug "[Mailchimp::User.update_unsubscribes] update unsubscribes emails: #{emails.join(", ")}"

          emails.each do |email|
            user = User.find_by_email(email)
            user.mailchimp_list.mark_unsubscribed! if user
          end
        end
      end

      # Update subscribed users
      #
      # usage:
      #  # for updating all subscribers
      #  Mailchimp::User.update_all
      #
      #  # update only user NAME field for existing users with 1,2,3 ids
      #  Mailchimp::User.update_all([1,2,3]) do |user|
      #     {:NAME => "name #{user.id}"}
      #  end
      def update_all(user_ids = [], options = {}, &parameters_block)
        default_options(options)
        find_options = {:batch_size => 100}
        find_options[:conditions] = {:id => user_ids} if user_ids.present?
        #
        ::User.subscribers.find_each(find_options) do |user|
          # @note: clone options if you will add params
          options[:parameters] = parameters_block.call(user) if block_given?

          update(user, options)
        end
      end

      def unsubscribe(email, options = {:validate => true})
        run do
          list = Mailchimp.list(options[:list])

          begin
            logger.debug "[Mailchimp::User.unsubscribe] unsubscribe '#{email}' email"

            # http://apidocs.mailchimp.com/api/1.3/listunsubscribe.func.php
            # listUnsubscribe(string apikey, string id, string email_address, boolean delete_member, boolean send_goodbye, boolean send_notify)
            hominid.list_unsubscribe(list.id, email, false, false, false)

            user = ::User.find_by_email(email)
            Mailchimp::UserList.new(user, list, options).mark_unsubscribed! if user
          rescue Hominid::APIError => error
            logger.error "[Mailchimp::User.unsubscribe] error: #{email}. #{error}"
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
      def default_options(options)
        options.reverse_merge!(
          :list         =>  default_list,
          :validate     =>  true,
          :double_optin =>  true
        )
      end

    end
  end
end