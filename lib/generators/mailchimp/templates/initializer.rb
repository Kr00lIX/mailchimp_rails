Rails.application.config.submodules = [:unsubscribe_hook]

Rails.application.config.mailchimp do |config|
  ## global

  config.api_key = ""

  config.reconnect_retries = 5

  config.default_email_user_format = "HTML"

  # --- user config ---
  config.user_config do |user|

    user.reject_method = :subscribed? # method or block

  end

  #config.on_subscribe do |event|
  #end

  #on_subscribe_error.email_banned do |user|
  #  user.error_subscribe!
  #end
  #
  #on_unsubscribe do
  #
  #end
  #
  #on_update do
  #
  #end

end  
  