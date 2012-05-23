module Mailchimp::Util

  def prepare_params(params)
    params.each do |key, value|
      params[key] =
          case(value)
          when TrueClass, FalseClass then prepare_bool(value)
          when NilClass then ""
          when String then sanitize_string(value)
          when Array then
            if key == :GROUPINGS # prepare group
              prepare_group(value)
            else
              prepare_array(value)
            end
          else
            value
          end
    end
  end

  def prepare_array(params, sep = ", ")
    #return params unless params.all?{ |param| param.is_a?(String) }
    params.map { |param| sanitize_string(param) }.join(sep)
  end

  def prepare_group_array(params)
    params.map { |param| sanitaze_group_name(param) }.join(",")
  end

  def prepare_group(group_params)
    group_params.each do |g|
      g[:name] = sanitize_string(g[:name]) if g.key?(:name)
      g[:groups] = prepare_group_array(g[:groups]) if g.key?(:groups) && g[:groups].is_a?(Array)
    end
    group_params
  end

  def sanitize_string(string)
    string
  end

  def sanitaze_group_name(string)
    string.gsub(/,/, "\\,")
  end

  def prepare_bool(val)
    val ? 1: 0
  end

  module_function :prepare_params, :prepare_array, :prepare_group_array, :prepare_group, :sanitize_string, :sanitaze_group_name,
                  :prepare_bool

end