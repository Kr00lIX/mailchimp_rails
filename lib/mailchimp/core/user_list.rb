# instance of list for user with custom params

# todo: add separate logic for user without subscription state
class Mailchimp::UserList

  attr_reader :user, :list, :options

  delegate :id, :name, :with_states?, :to => :list

  def initialize(user, list, options = {})
    options.reverse_merge!(:validate => true)

    @user, @list = user, list
    @options = options
  end

  def parameters
    @parameters ||= options[:parameters] || list.parameters(user)
  end

  def subscribed?
    with_states? && options[:validate]? user.subscribed?: true
  end

  # todo: move this to states module as callback
  def mark_unsubscribed!
    return unless with_states?
    # todo: move to callback
    user.unsubscribe! if user.subscribed?
  end

  # todo: move this to states module as callback
  def mark_subscribed!
    return unless with_states?

    unless user.subscribed?
      user.skip_mailchimp_callbacks = true
      user.subscribe!
    end
  end

  # todo: move this to states module as callback
  def subscription_error(exception)
    return unless with_states?

    user.skip_mailchimp_callbacks = true
    user.subscription_last_error = exception.message
    user.error_subscribe!
  end

end
