class Mailchimp::List

  DEFAULT_NAME = :main

  attr_reader :params, :params_proc

  class << self
    def lists
      @lists ||= {}
    end

    def instances
      @instances ||= {}
    end

    def register(name, params = {}, &params_proc)
      name ||= DEFAULT_NAME
      raise "list with #{name} name already defined" if lists.key?(name)
      raise ArgumentError, "undefined params block" unless params[:params_proc].is_a?(Proc)
      lists[name] = params
      name
    end

    def [](name)
      name ||= DEFAULT_NAME
      raise ArgumentError, "list with '#{name}' name not found" unless lists.key?(name)
      instances[name] ||= new(lists[name])
    end
  end

  def initialize(options,  params= {})
    @params = options
    @params_proc = options[:params_proc]
  end

  def params(model)
    params_proc.call(model)
  end

end
