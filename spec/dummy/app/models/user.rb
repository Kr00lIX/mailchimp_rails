class User < ActiveRecord::Base

  attr_accessible :email, :first_name, :last_name, :want_mail

  ## plugins
  mailchimp_user do |user|
    {
        EMAIL: user.email,
        NAME: user.full_name
    }
  end

  mailchimp_user :list => :second, :subscription_state => false do |user|
    {
       EMAIL: user.email,
       TITLE: user.title
    }
  end

  #mailchimp_before_send do |user|
  #  #user.mailchimp.
  #end
  #
  #mailchimp_after_send do
  #
  #end

  def full_name
    "#{first_name} #{last_name}"
  end

  def title
    "title #{id}"
  end

end
