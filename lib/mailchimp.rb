# -*- encoding: utf-8 -*-
require 'active_record'
require "active_support/all"
require "action_pack"

module Mailchimp

  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    extend ActiveSupport::Autoload

    autoload_under 'core' do
      autoload :Base
      autoload :List
      autoload :UserList
      autoload :UserModel
      autoload :User
      autoload :Group
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
    require "mailchimp/core/list"
    require "mailchimp/core/user_list"
    require "mailchimp/core/user_model"
    require "mailchimp/core/user"
    require "mailchimp/core/group"
    require "mailchimp/core/web_hook"
    require "mailchimp/core/util"
    require "mailchimp/controllers/web_hooks_controller"
    require "mailchimp/errors/error"
    require "mailchimp/errors/not_emplemented"
  end

  if defined?(::ActiveRecord)
    ::ActiveRecord::Base.send(:include, Mailchimp::UserModel)
  end

  class << self
    delegate :routes, :to => "Mailchimp::WebHooksController"
    delegate :config, :enabled?, :logger, :to => "Mailchimp::Base"
    delegate :list, :to => "Mailchimp::List"
  end

end

Mailchimp::Base.init_mailchimp