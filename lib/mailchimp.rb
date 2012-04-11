require "mailchimp/version"
require 'rails'
require 'active_record'
require "active_support/all"
require "action_pack"

module Mailchimp
  extend ActiveSupport::Autoload

  autoload_under 'core' do
    autoload :Base
    autoload :ActiveRecordExtensions
    autoload :User
    autoload :WebHook
  end

  autoload :Controller

  module Controller
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :WebHooks
  end

  autoload_under 'error' do
    autoload :NotEmplementedError
  end

  if defined?(ActiveRecord)
    ActiveRecord::Base.send(:include, Mailchimp::ActiveRecordExtensions)
  end

  require 'mailchimp/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  class << self
    delegate :routes, :to => "Mailchimp::Controller::WebHooks"
    delegate :config, :enabled?, :logger, :to => "Mailchimp::Base"
  end


end
