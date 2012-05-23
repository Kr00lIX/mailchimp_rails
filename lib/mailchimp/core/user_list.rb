# instance of list for user with custom params

# todo: add separate logic for user without subscription state
class Mailchimp::UserList

  attr_reader :user, :list, :options

  delegate :id, :name, :to => :list

  def initialize(user, list, options ={})
    options.reverse_merge!(:validate => true)

    @user, @list = user, list
    @options = options
  end

  def parameters
    @parameters ||= options[:parameters] || list.parameters(user)
  end

  def subscribed?
    options[:validate]? user.subscribed?: true
  end

  def mark_unsubscribed!
    # todo: move to callback
    user.unsubscribe! if user.subscribed?
  end

  def mark_subscribed!
    unless user.subscribed?
      user.skip_mailchimp_callbacks = true
      user.subscribe!
    end
  end

  def subscription_error(exception)
    user.skip_mailchimp_callbacks = true
    user.subscription_last_error = exception.message
    user.error_subscribe!
  end

end
