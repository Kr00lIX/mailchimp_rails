require 'mailchimp'

module Mailchimp
  class Engine < ::Rails::Engine

    engine_name :mailchimp

    config.mailchimp = ::Mailchimp::Controller::Config

    #paths.app.controllers = "lib/controllers"

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end

    rake_tasks do
      load "mailchimp/railties/tasks.rake"
    end
    
  end
end