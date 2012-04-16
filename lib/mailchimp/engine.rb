require 'mailchimp'

module Mailchimp
  class Engine < ::Rails::Engine

    engine_name :mailchimp

    #config.before_initialize do
    #  Mailchimp::Base.load_config
    #end

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end

  end
end