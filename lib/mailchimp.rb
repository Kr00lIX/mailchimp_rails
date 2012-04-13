
require "mailchimp/version"
require 'active_record'
require "active_support/all"
require "action_pack"


module Mailchimp

  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    extend ActiveSupport::Autoload

    autoload :Base, "mailchimp/core/base.rb"
    autoload :ActiveRecordExtensions, "mailchimp/core/active_record_extensions.rb"
    autoload :User, "mailchimp/core/user.rb"
    autoload :WebHook,  "mailchimp/core/web_hook.rb"
    autoload :Util, "mailchimp/core/util.rb"

    autoload_under 'core' do
      autoload :Base
      autoload :ActiveRecordExtensions
      autoload :User
      autoload :WebHook
      autoload :Util
    end

    autoload_under "controllers" do
      autoload :WebHooksController
    end

    autoload_under 'errors' do
      autoload :Error
      autoload :NotEmplemented
    end

    require 'rails'
    require 'mailchimp/engine'

  else

    require "mailchimp/core/base"
    require "mailchimp/core/active_record_extensions"
    require "mailchimp/core/user"
    require "mailchimp/core/web_hook"
    require "mailchimp/core/util"
    require "mailchimp/controllers/web_hooks_controller"
    require "mailchimp/errors/error"
    require "mailchimp/errors/not_emplemented"
  end

  if defined?(::ActiveRecord)
    ::ActiveRecord::Base.send(:include, Mailchimp::ActiveRecordExtensions)
  end

  class << self
    delegate :routes, :to => "Mailchimp::WebHooksController"
    delegate :config, :enabled?, :logger, :to => "Mailchimp::Base"
  end

end
