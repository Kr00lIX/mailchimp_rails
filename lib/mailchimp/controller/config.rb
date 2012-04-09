module Mailchimp::Controller
  module Config
    class << self
      attr_accessor :reconnect_retries, :param2, :submodules

      def init!
        @defaults = {
          :@reconnect_retries  => 5,
          :@param2    => "default param 2"
        }
      end

      # Resets all configuration options to their default values.
      def reset!
        @defaults.each do |k,v|
          instance_variable_set(k, v)
        end
      end

      def update!
        @defaults.each do |k,v|
          instance_variable_set(k,v) if !instance_variable_defined?(k)
        end
      end

      def user_config(&blk)
        # block_given? ? @user_config = blk : @user_config
      end

      def configure(&blk)
        @configure_blk = blk
      end

      def configure!
        @configure_blk.call(self) if @configure_blk
      end
    end
    init!
    reset!
  end
end