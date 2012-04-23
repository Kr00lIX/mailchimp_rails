class Mailchimp::Group < Mailchimp::Base

  def self.add(group_name, options = {})
    run do
      begin
        list_id = options[:list_id] || config[:list_id]
        group_id = options[:group_id]

        # http://apidocs.mailchimp.com/api/1.3/listinterestgroupadd.func.php
        # string apikey, string id, string group_name, int grouping_id
        hominid.list_interest_group_add(list_id, group_name, group_id)
      rescue Hominid::APIError => error
        logger.error "[Mailchimp::Group.add] error: #{group_name}. #{error}"
        case(error.fault_code)
          when 270 # Oops! Group names need to be unique.
            # notify and skip
            notify(error, :group_name => group_name, :list_id => list_id, :group_id => group_id, :options => options)
          else
            raise error
        end
      end
    end
  end
end