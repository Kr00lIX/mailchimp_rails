module Mailchimp::Generators
  class InstallGenerator < Rails::Generators::Base

    desc "Installs Mailchimp and generates the necessary migrations"

    include Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

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

    def setup_routes
      route("match 'api/mailchimp' => Mailchimp.routes")
    end

    def create_migrations
      migration_template("migrations/add_mailchimp_state_columns_to_user.rb", "db/migrate/add_mailchimp_state_columns_to_user.rb")
    end

  end
end