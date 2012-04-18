#
# http://apidocs.mailchimp.com/webhooks/
#
class Mailchimp::WebHook < Mailchimp::Base

  #"data[action]": "unsub",
  #"data[reason]": "manual",
  #"data[id]": "8a25ff1d98",
  #"data[list_id]": "a6b5da1054",
  #"data[email]": "api+unsub@mailchimp.com",
  #"data[email_type]": "html",
  #"data[reason]": "hard"
  def self.unsubscribe(params)
    return unless enabled? && valid?(params)

    logger.debug "[Mailchimp::WebHook.unsubscribe] mark unsubscribe user '#{params[:email]}'"
    user = ::User.find_by_email(params[:email])
    return false unless user

    user.skip_mailchimp_callbacks = true
    user.unsubscribe!
  end

  private

  def self.valid?(params)
    params && params[:list_id] == config[:list_id] && params[:email]
  end

end
