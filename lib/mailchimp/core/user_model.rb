require "state_machine"

module Mailchimp::UserModel

  # This module handles all plugin operations which are related to the Model layer in the MVC pattern.
  # It should be included into the ORM base class.
  # In the case of Rails this is usually ActiveRecord (actually, in that case, the plugin does this automatically).
  #
  # When included it defines a single method: 'mailchimp_user'
  # which when called adds the other capabilities to the class.
  def self.included(klass)
    klass.class_eval do

      def self.mailchimp_user(options = {}, &block)
        options.reverse_merge!(
          :subscription_state => :subscription_state
        )

        # todo: check config data
        Mailchimp::Base.load_config

        list_name = Mailchimp::List.register(options[:list], :params_proc => block)

        self.class_eval do
          extend ClassMethods
          include InstanceMethods
          include CallBacks

          if options[:subscription_state]

            # flag for skiping mailchimp callbacks on changing state
            attr_accessor :skip_mailchimp_callbacks

            ## define named scopes
            def_scope =
                    if Rails::VERSION::MAJOR == 3
                      proc { |name, state| scope name, where(:subscription_state => state) }
                    else
                      proc { |name, state| named_scope name, :conditions => {:subscription_state => state} }
                    end
            {:subscribers => "subscribed", :unsubscribers => "unsubscribed", :subscription_error => "error"}.each(&def_scope)

            state_machine options[:subscription_state], :initial => :subscribed do

              event :subscribe do
                transition all => :subscribed
              end

              event :unsubscribe do
                transition all => :unsubscribed
              end

              event :error_subscribe do
                transition all => :error
              end

              after_transition all => :subscribed do |user, transition|
                Mailchimp::User.subscribe(user, :list => list_name) unless user.skip_mailchimp_callbacks
              end

              after_transition all => :unsubscribed do |user, transition|
                Mailchimp::User.unsubscribe(user.email, :list => list_name) unless user.skip_mailchimp_callbacks
              end
            end
          end

        end
      end
    end
  end

  module ClassMethods
    # Returns the class instance variable for configuration, when called by the class itself.
    def mailchimp_params_proc(list_name = nil)
      Mailchimp::List[list_name].params_proc
    end

    def update_all_mailchimp
      # todo: сделать через массовый subscribe с обновлением
      #
      find_each(:batch_size => 50).collect(&:update_mailchimp)
    end
  end

  module InstanceMethods

    def mailchimp_data(list_name = nil)
      #binding.pry
      Mailchimp::Util.prepare_params(Mailchimp::List[list_name].params(self))
    end

    def update_mailchimp(options = {})
      Mailchimp::User.update(self, options)
    end
  end

  module CallBacks
    def mailchimp_before_send

    end

    def mailchimp_after_send

    end



  end

end