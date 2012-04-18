class Mailchimp::Group < Mailchimp::Base

  def self.add(group_name, options = {})
    run do
      list_id = options[:list_id] || config[:list_id]
      group_id = options[:group_id]

      # http://apidocs.mailchimp.com/api/1.3/listinterestgroupadd.func.php
      # string apikey, string id, string group_name, int grouping_id
      hominid.list_interest_group_add(list_id, group_name, group_id)
    end
  end

end