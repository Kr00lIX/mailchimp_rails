class Mailchimp::List

  DEFAULT_NAME = :main

  attr_reader :params, :params_proc, :id, :name

  class << self
    def lists
      @lists ||= {}
    end

    def instances
      @instances ||= {}
    end

    def register(name, params = {})
      name ||= DEFAULT_NAME
      raise "list with #{name} name already defined" if lists.key?(name)
      raise ArgumentError, "undefined params block" unless params[:params_proc].is_a?(Proc)
      lists[name] = params
      name
    end

    def list(name = nil)
      name ||= DEFAULT_NAME
      raise ArgumentError, "list with '#{name}' name not found" unless lists.key?(name)

      instances[name] ||= new(lists[name].merge(:name => name))
    end
    alias_method :[], :list

  end

  def initialize(options)
    @params = options
    @name = options[:name]
    @params_proc = options[:params_proc]

    config = Mailchimp.config
    @id =
      case(name)
        when :main then config[:list_id] || config[:main_list_id]
        when String then name
        when Symbol then config[:"#{name}_list_id"]
        else
          raise ArgumentError, "couldn't find list_id for '#{name} list"
      end

    @with_states = !!options[:subscription_state] # check using user subscription states
  end

  def with_states?
    @with_states
  end

  def parameters(model)
    params_proc.call(model)
  end

end
