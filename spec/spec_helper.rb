# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

Dir.chdir(File.expand_path("../dummy", __FILE__)) { require File.expand_path("config/environment") }

require 'rspec/rails'
require 'capybara/rspec'
require "factory_girl_rails"
require "ffaker"
require 'pry'



ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.mock_with :rspec

  config.include Capybara::DSL #, :example_group => { :file_path => /\bspec\/requests\// }

  config.include FactoryGirl::Syntax::Methods

  #config.include Mailchimp::Engine.routes.url_helpers
  #include Rails.application.routes.url_helpers


  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

end

