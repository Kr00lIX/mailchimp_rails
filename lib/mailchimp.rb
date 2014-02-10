# -*- encoding: utf-8 -*-
require 'active_record'
require "active_support/all"
require "action_pack"

module Mailchimp

  extend ActiveSupport::Autoload

  autoload_under 'core' do
    autoload :Base
    autoload :List
    autoload :UserList
    autoload :UserModel
    autoload :User
    autoload :Group
    autoload :Campaign
    autoload :Ecommerce
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


  if defined?(::ActiveRecord)
    ::ActiveRecord::Base.send(:include, Mailchimp::UserModel)
  end

  class << self
    delegate :routes, :to => "Mailchimp::WebHooksController"
    delegate :config, :enabled?, :logger, :to => "Mailchimp::Base"
    delegate :list, :to => "Mailchimp::List"
  end

end

Mailchimp::Base.init_mailchimp unless defined?(Rails) && Rails::VERSION::MAJOR == 3
XMLRPC::Client.include XMLRPC::ClientFixContentLenght if RUBY_VERSION.split(".").first.eql?("2")