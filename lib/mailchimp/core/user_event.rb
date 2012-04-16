# -*- encoding: utf-8 -*-
class Mailchimp::UserEvent
  class << self
    def subscription_error(user, exception)
      user.subscription_last_error = exception.message
      user.error_subscribe!
    end
  end
end
