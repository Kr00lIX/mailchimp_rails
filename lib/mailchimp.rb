require "mailchimp/version"
require 'rails'
require 'active_record'
require "active_support/all"
require "action_pack"

module Mailchimp
  extend ActiveSupport::Autoload

  autoload_under 'error' do
    autoload :NotEmplementedError
  end

  autoload :Base
  autoload :Model
  autoload :Controller
  autoload :WebHook


  module Controller
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :WebHooks
  end

  if defined?(ActiveRecord)
    ActiveRecord::Base.send(:include, Mailchimp::Model)
  end

  require 'mailchimp/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  class << self
    delegate :routes, :to => "Mailchimp::Controller::WebHooks"
  end
end
