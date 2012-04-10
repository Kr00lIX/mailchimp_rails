module Mailchimp
  # This module handles all plugin operations which are related to the Model layer in the MVC pattern.
  # It should be included into the ORM base class.
  # In the case of Rails this is usually ActiveRecord (actually, in that case, the plugin does this automatically).
  #
  # When included it defines a single method: 'mailchimp_user'
  # which when called adds the other capabilities to the class.
  module Model
    def self.included(klass)
      klass.class_eval do
        class << self
          def mailchimp_data(&block)

            # todo: validate block
            @mailchimp_params_proc = block

            self.class_eval do
              extend ClassMethods
              include InstanceMethods
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
    end
  end
end