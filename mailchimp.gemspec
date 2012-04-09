# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mailchimp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "mailchimp"

  gem.authors       = ["Anatoliy Kovalchuk"]
  gem.email         = ["kr00lix@gmail.com"]
  gem.description   = %q{Mailchimp API wrapper}
  gem.summary       = %q{Mailchimp API wrapper through Hominid}
  gem.homepage      = "http://github.com/prophotos/mailchimp"


  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.version       = Mailchimp::VERSION
  gem.platform      = Gem::Platform::RUBY

  gem.add_dependency "rails", "~> 3.2.3"
  gem.add_dependency "hominid", "~> 3.0.4"

  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "rspec-rails", "~> 2.8.0"
  gem.add_development_dependency 'factory_girl_rails'
  gem.add_development_dependency 'ffaker'
  gem.add_development_dependency 'debugger'
end
