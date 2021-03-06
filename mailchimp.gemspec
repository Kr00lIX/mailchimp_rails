# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mailchimp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "mailchimp-rails"

  gem.authors       = ["Anatoliy Kovalchuk"]
  gem.email         = ["kr00lix@gmail.com"]
  gem.description   = %q{Mailchimp API wrapper}
  gem.summary       = %q{Mailchimp API wrapper through Hominid}
  gem.homepage      = "http://github.com/Kr00lIX/mailchimp_rails"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.version       = Mailchimp::VERSION
  gem.platform      = Gem::Platform::RUBY

  gem.add_dependency "rails", ">= 2.3.11" #, "~> 3.1.0"
  gem.add_dependency "hominid", "~> 3.0.5"
  gem.add_dependency 'state_machine'

  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake", ">= 12.3.3"
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "rspec-rails", "~> 2.8.0"
  gem.add_development_dependency 'factory_girl_rails'
  gem.add_development_dependency 'ffaker'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency "capybara"

  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "ruby_gntp"
  gem.add_development_dependency "launchy"
  gem.add_development_dependency "rb-fsevent"

end

