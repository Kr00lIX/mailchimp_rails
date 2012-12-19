module Mailchimp
  class Campaign < Base

    def self.fetch_each(filters = {}, batch_size = 300)
      logger.debug "[Mailchimp.find_each] with #{batch_size} batch size"
      start = -1
      loop do
        fetched_data = all(filters, start += 1, batch_size)
        break if fetched_data["data"].empty?

        fetched_data["data"].each do |campaign|
          yield(campaign)
        end

        sleep(rand(0.5))
      end
    end

    # list of campaigns and their details
    # filters
    #  :sendtime_start => # YYYY-MM-DD HH:mm:ss
    #
    # @note http://apidocs.mailchimp.com/api/1.3/campaigns.func.php
    def self.all(filters = {}, start = 0, limit = 25)
      run do
        logger.debug "[Mailchimp.all] start=#{start}, limit=#{limit}"
        hominid.campaigns(filters, start, limit)
      end
    end

    def self.fetch_each_member(campaign_id, batch_size = 1000)
      logger.debug "[Mailchimp.find_each] with '#{campaign_id}' campaign id"
      start = -1
      loop do
        fetched_data = members(campaign_id, start += 1, batch_size)
        break if !fetched_data || fetched_data["data"].empty?

        fetched_data["data"].each do |member|
          yield(member)
        end

        sleep(rand(0.5))
      end
    end

    def self.members(campaign_id, start = 0, limit = 1000)
      run do
        logger.debug "[Mailchimp.members] start=#{start}, limit=#{limit}"
        begin
          hominid.campaignMembers(campaign_id,  "", start, limit)
        rescue Hominid::APIError => error
          logger.error "[Mailchimp::Campaign.members] error get links for ##{campaign_id} campaign. #{error}"
          case(error.fault_code)
            when 301
              logger.error "[Mailchimp::Campaign.members] Campaign stats are not available until the campaign has been completely sent."
              nil # skip this error
            else
              raise error
          end
        end
      end
    end

    # http://apidocs.mailchimp.com/api/1.3/campaignclickstats.func.php
    def self.links(campaign_id)
      run do
        begin
          hominid.campaignClickStats(campaign_id)
        rescue Hominid::APIError => error
          logger.error "[Mailchimp::Campaign.links] error get links for ##{campaign_id} campaign. #{error}"
          case(error.fault_code)
            when 301
              logger.error "[Mailchimp::Campaign.links] Campaign stats are not available until the campaign has been completely sent."
              nil # skip this error
            else
              raise error
          end
        end
      end
    end

    def self.fetch_each_link_clicks(cid, url, batch_size = 1000)
      start = -1
      loop do
        fetched_data = link_clicks(cid, url, start += 1, batch_size)
        break if fetched_data["data"].empty?

        fetched_data["data"].each do |clicks|
          yield(clicks)
        end

        sleep(rand(0.5))
      end
    end

    def self.link_clicks(cid, url, start = 0, limit = 1000)
      run do
        hominid.campaignClickDetailAIM(cid, url, start, limit)
      end
    end

  end
end