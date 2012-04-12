require 'rails/generators'
require 'rails/generators/migration'

class Mailchimp::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def create_config_file
    template 'config/mailchimp.yml', 'config/mailchimp.yml'
  end

  def create_migrations
    Dir[File.join(self.class.source_root, 'migrations/*.rb')].sort.each do |template|
      basename = File.basename(template).gsub(/^\d+_/, '')
      if self.class.migration_exists?(File.join(Rails.root, 'db/migrate'), basename.sub(/\.rb$/, '')).blank?
        migration_template template, "db/migrate/#{basename}"
        sleep 1
      end
    end
  end

end