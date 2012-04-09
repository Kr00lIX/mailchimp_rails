class Mailchimp::Base
  class << self
    def hominid
      @@hominid ||= Hominid::API.new(config[:api_key], {:secure => true, :timeout => 300})
    end

    def config
      #todo: implement config
      {}
    end
  end
end