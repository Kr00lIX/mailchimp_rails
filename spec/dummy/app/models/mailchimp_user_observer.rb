class MailchimpUserObserver < ActiveRecord::Observer
  observe :user

  #def after_create(user)
  #  Mailchimp::User.subscribe(user)
  #end

  def after_destroy(user)
    Mailchimp::User.unsubscribe(user.email)
  end

  #def after_update(user)
  #  Mailchimp::User.update(user)
  #end

end
