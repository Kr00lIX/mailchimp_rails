require 'mailchimp'

module Mailchimp
  class Engine < ::Rails::Engine

    engine_name :mailchimp

    config.mailchimp = ::Mailchimp::Controller::Config

    #initializer 'mailing.action_mailer' do |app|
    #  ActiveSupport.on_load :action_mailer do
    #    include Mailing::ActionMailerExtensions
    #  end
    #
    #
    #end
    #
    config.before_initialize do
      Mailchimp::Base.load_config
    end
    #
    #config.to_prepare do
    #  Mailing.reset_layouts! unless Rails.env.production?
    #end

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end

  end
end