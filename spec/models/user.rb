# encoding: utf-8
require "ostruct"

class User < OpenStruct
  include Mailchimp::Model


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