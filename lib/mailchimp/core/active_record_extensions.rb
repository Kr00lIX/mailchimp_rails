require "state_machine"

module Mailchimp
  # This module handles all plugin operations which are related to the Model layer in the MVC pattern.
  # It should be included into the ORM base class.
  # In the case of Rails this is usually ActiveRecord (actually, in that case, the plugin does this automatically).
  #
  # When included it defines a single method: 'mailchimp_user'
  # which when called adds the other capabilities to the class.
  module ActiveRecordExtensions
    def self.included(klass)
      klass.class_eval do
        class << self
          def mailchimp_user(&block)

            # todo: validate block
            @mailchimp_params_proc = block

            self.class_eval do
              extend ClassMethods
              include InstanceMethods
            end

            scope :subscribers, where(:subscription_state => "active")

            state_machine :subscription_state, :initial => :active do

              event :subscribe do
                transition [:active, :disabled, :error] => :active
              end

              event :unsubscribe do
                transition [:active, :disabled, :error] => :unsubscribed
              end

              event :error_subscribe do
                transition [:active, :disabled, :error] => :disabled
              end
            end

          end
        end
      end
    end

    module ClassMethods
      # Returns the class instance variable for configuration, when called by the class itself.
      def mailchimp_params_proc
        @mailchimp_params_proc
      end
    end

    module InstanceMethods

      def mailchimp_data
        # todo: save data to val and clear after changing model
        self.class.mailchimp_params_proc.call(self)
      end

      def subscribed?
        subscription_state == "active"
      end

      def update_mailchimp
        Mailchimp::User.update(self)
      end
    end
  end
end