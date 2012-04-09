# encoding: utf-8

# http://apidocs.mailchimp.com/webhooks/
module Mailchimp::Controller
  class WebHooks < ::ApplicationController

    def self.routes
      action(:index)
    end

    # universal action for all hooks
    def index
      case(params[:type])
      when "unsubscribe" then unsubscribe
      when "subscribe" then subscribe
      when "profile" then update_profile
      when "upemail" then change_email
      when "cleaned" then cleaned_email
      else  render :text => "blank action"
      end
    end

    def subscribe
      raise Mailchimp::NotEmplementedError, "subscribe action"
    end

    #  "type": "unsubscribe",
    #  "data[action]": "unsub",
    #  "data[reason]": "manual",
    #  "data[id]": "8a25ff1d98",
    #  "data[list_id]": "a6b5da1054",
    #  "data[email]": "api+unsub@mailchimp.com",
    #  "data[email_type]": "html",
    #  "data[reason]": "hard"
    def unsubscribe
      Mailchimp::WebHook.unsubscribe(params)
      render :text => "ok"
    end

    # update profile
    #
    # @params:
    #  "type": "profile",
    #  "fired_at": "2009-03-26 21:31:21",
    #  "data[id]": "8a25ff1d98",
    #  "data[list_id]": "a6b5da1054",
    #  "data[email]": "api@mailchimp.com",
    #  "data[email_type]": "html",
    #  "data[merges][EMAIL]": "api@mailchimp.com",
    #  "data[merges][FNAME]": "MailChimp",
    #  "data[merges][LNAME]": "API",
    #  "data[merges][INTERESTS]": "Group1,Group2",
    #  "data[ip_opt]": "10.20.10.30"
    def update_profile
      raise Mailchimp::NotEmplementedError, "update profile action"
    end

    # @params:
    #  "type": "upemail",
    #  "fired_at": "2009-03-26\ 22:15:09",
    #  "data[list_id]": "a6b5da1054",
    #  "data[new_id]": "51da8c3259",
    #  "data[new_email]": "api+new@mailchimp.com",
    #  "data[old_email]": "api+old@mailchimp.com"
    def change_email
      raise Mailchimp::NotEmplementedError, "change email action"
    end

    # Cleaned Emails
    # will be one of "hard" (for hard bounces) or "abuse"
    #
    # @params:
    #  "type": "cleaned",
    #  "fired_at": "2009-03-26 22:01:00",
    #  "data[list_id]": "a6b5da1054",
    #  "data[campaign_id]": "4fjk2ma9xd",
    #  "data[reason]": "hard",
    #  "data[email]": "api+cleaned@mailchimp.com"
    def cleaned_email
      raise Mailchimp::NotEmplementedError, "cleaned email action"
    end
  end
end
