require "hominid"

class Mailchimp::Base

  @@config = {}
  cattr_accessor :config

  class << self

    def load_mailchimp_config
      self.config = {} # clear previos data
      config_hash = YAML.load_file(Rails.root + "config/mailchimp.yml")
      if config_hash && config_hash[Rails.env]
        self.config = config_hash[Rails.env].symbolize_keys
      end
    rescue
      # ignore configuration errors, MailListsManager will be disabled
    end

    def hominid
      @@hominid ||= Hominid::API.new(config[:api_key], {:secure => true, :timeout => 300})
    end

    def enabled?
      @@config && @@config[:enabled] == true
    end

    def run(retries = 10, &block)
      return false unless enabled?

      begin
        yield(hominid)
      rescue Hominid::APIError => error
        case(error.fault_code)
          # No more than 10 simultaneous connections allowed.
          # see(http://apidocs.mailchimp.com/api/faq/#faq6)
          when -50
            logger.error "[Mailchimp::Base.run] error more than 10 simultaneous connections. Sleeping... 5 seconds"
            sleep(6)
            retry
        else
          raise error
        end
      rescue Exception => error
        called_method = caller[0][/`.*'/][1..-2]
        logger.error("[Mailchimp::Base.#{called_method}] Error ##{retries}': #{error.to_s}")
        if (retries -= 1) > 0
          sleep(3) unless Rails.env.test?
          retry
        end
        raise error
      end
    end

    # @param [Symbol, String, Nil] list - list token or list name, by default is a list_id
    def unsubscribes(list = nil, campaign_ids = nil)
      campaigns = campaign_ids &&  Array(campaign_ids) || last_campaigns(list, :status => "sent")
      return false if campaigns.blank?

      logger.info "[Mailchimp.unsubscribes] campaigns ids: #{campaigns.join(", ")}"

      campaigns.collect do |cid|
        begin
          run do
            # http://apidocs.mailchimp.com/api/1.3/campaignunsubscribes.func.php
            res = hominid.campaignUnsubscribes(cid)
            if block_given?
              yield(res)
            else
              res
            end
          end
        rescue REXML::ParseException => e
          # for someone campaign returns invalid xml
          logger.error "[Mailchimp.unsubscribes] Error parse XML: #{e}"
          nil
        end
      end
    end

    # fetch last campaign ids
    def last_campaigns(list_name = nil, filters = {})
      run do
        begin
          # http://apidocs.mailchimp.com/api/1.3/campaigns.func.php
          list = Mailchimp::List[list_name]
          campaigns = hominid.campaigns({:list_id => list.id}.merge(filters))

          campaigns['data'].collect{ |campaign| campaign["id"] }
        rescue Hominid::APIError => error
          #<301> Campaign stats are not available until the campaign has been completely sent.
          raise error
        end
      end
    end

    def logger
      ::Rails.logger
    end

    def notify(exception, params)
      return unless defined?(::Airbrake)
      ::Airbrake.notify(exception, :parameters => params)
    end
  end
end

Mailchimp::Base.load_mailchimp_config