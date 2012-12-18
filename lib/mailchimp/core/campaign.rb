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
        break if fetched_data["data"].empty?

        fetched_data["data"].each do |member|
          yield(member)
        end

        sleep(rand(0.5))
      end
    end

    def self.members(campaign_id, start = 0, limit = 1000)
      run do
        logger.debug "[Mailchimp.fetch_members] start=#{start}, limit=#{limit}"
        hominid.campaignMembers(campaign_id,  "", start, limit)
      end
    end

    # http://apidocs.mailchimp.com/api/1.3/campaignclickstats.func.php
    def self.links(campaign_id)
      run do
        hominid.campaignClickStats(campaign_id)
      end
    end

  end
end