namespace :mailchimp do
  namespace :update do
    desc "Update all users with errors"
    task :disabled do
      # todo: implement this
    end

    desc "Update all subscribed users"
    task :subscribed do
      Mailchimp::User.update_all
    end
  end
end