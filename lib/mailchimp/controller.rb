module Mailchimp
  module Controller
    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
      end
      Config.update!
      Config.configure!
    end
    
    module InstanceMethods
    end  
  end  
end