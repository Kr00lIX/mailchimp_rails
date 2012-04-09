require 'fileutils'

namespace :mailchimp do
  desc "Adds mailchimp's initializer file"
  task :bootstrap do
    src = File.join(File.dirname(__FILE__), '..', '..', 'gemerators/tempates', 'initializer.rb')
    target = File.join(Rails.root, "config", "initializers", "mailchimp.rb")
    FileUtils.cp(src, target)
  end
end