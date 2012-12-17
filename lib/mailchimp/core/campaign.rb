module Mailchimp
  class Campaign < Base

    def self.fetch_each(filters = {}, batch_size = 300)
      logger.debug "Mailchimp.find_each with #{batch_size} batch size"
      start = 0
      loop do
        fetched_data = fetch(filters, start, batch_size)
        break if fetched_data["data"].empty?

        fetched_data["data"].each do |campaign|
          yield(campaign)
        end

        sleep(rand(0.5))
        start += 1
      end
    end

    # list of campaigns and their details
    # filters
    #  :sendtime_start => # YYYY-MM-DD HH:mm:ss
    #
    # @note http://apidocs.mailchimp.com/api/1.3/campaigns.func.php
    def self.fetch(filters = {}, start = 0, limit = 25)
      hominid.campaigns(filters, start, limit)
    end

  end
end