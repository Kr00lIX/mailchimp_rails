class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  ## plugins
  mailchimp_data do |user|
    {
        EMAIL: user.email,
        NAME: user.full_name
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
