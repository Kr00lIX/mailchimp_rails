require "hominid"

class Mailchimp::Base

  @@config = {}
  cattr_accessor :config

  class << self

    def load_config
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
      rescue Exception => error
        called_method = caller[0][/`.*'/][1..-2]
        logger.error("[Mailchimp::Base.#{called_method}] Error ##{retries}': #{error.to_s}")
        if (retries -= 1) > 0
          sleep(0.5)
          retry
        end
        raise error
      end
    end

    def unsubscribes(list_id = nil, campaign_ids = nil)
      campaigns = campaign_ids &&  Array(campaign_ids) || last_campaigns(list_id, :status => "sent")
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
    def last_campaigns(list_id = nil, filters = {})
      run do
        list_id ||= config[:list_id]
        begin
          # http://apidocs.mailchimp.com/api/1.3/campaigns.func.php
          campaigns = hominid.campaigns({:list_id => list_id}.merge(filters))

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

  end
end

Mailchimp::Base.load_config