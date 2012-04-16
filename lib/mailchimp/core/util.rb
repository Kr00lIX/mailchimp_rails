module Mailchimp::Util

  def prepare_params(params)
    params.each do |key, value|
      params[key] =
          case(value)
          when TrueClass, FalseClass then prepare_bool(value)
          when NilClass then ""
          when String then sanitize_string(value)
          when Array then prepare_array(value)
          else
            value
          end
    end
  end

  # prepare array only if it include only strings
  def prepare_array(params, sep = ",")
    return params unless params.all?{ |param| param.is_a?(String) }
    params.map { |param| sanitize_string(param) }.join(sep)
  end

  def sanitize_string(string)
    string.gsub(/,/, "\\,")
  end

  def prepare_bool(val)
    val ? 1: 0
  end

  module_function :prepare_params, :prepare_array, :sanitize_string, :prepare_bool

end