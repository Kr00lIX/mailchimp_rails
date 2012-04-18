# encoding: utf-8
require "spec_helper"

describe Mailchimp::WebHook do

  describe ".unsubscribe" do
    let!(:user){ build(:user) }
    let!(:email){ user.email }

    before do
      Mailchimp::User.should_not_receive :unsubscribe
    end

    it "should run find email for user" do
      Mailchimp::Base.stub!(:enabled? => true, :valid? => true)

      ::User.should_receive(:find_by_email).with(email).and_return(user)
      Mailchimp::WebHook.unsubscribe(:email => email)
    end

    it "should not update user for disabled mailchimp"  do
      User.should_not_receive(:find_by_email).with(email)
      Mailchimp::WebHook.stub!(:enabled? => false)

      Mailchimp::WebHook.unsubscribe(:email => email)
    end

    it "shoud update user for invalid data" do
      valid_list_id = "some token"
      User.should_receive(:find_by_email).with(email)
      Mailchimp::WebHook.stub!(:enabled? => true, :config => {:list_id => valid_list_id})

      Mailchimp::WebHook.unsubscribe(:email => email, :list_id => valid_list_id)
    end

  end

end