# encoding: utf-8
require "spec_helper"

describe MailchimpUserObserver do

  describe "#create" do
    it "should subscribe" do
      pending
      user = build(:subscribed_user)
      user.should be_subscribed
      Mailchimp::User.should_receive(:subscribe).with(user)
      user.save
    end

    it "should not subscribe if it doesn't want email" do
      pending
      user = build(:unsubscribed_user)
      Mailchimp::User.should_not_receive(:subscribe)
      user.save
    end
  end

  describe "#update" do
    let(:user){ create(:user) }

    it "should call update method" do
      pending
      Mailchimp::User.should_not_receive(:subscribe)
      Mailchimp::User.should_receive(:update).with(user).any_number_of_times

      user.update_attributes(:email => "new_email@example.com")
    end
  end

  describe "#destroy" do
    let(:user){ create(:user) }

    it "should unsubscribe user" do
      Mailchimp::User.should_receive(:unsubscribe).with(user.email)
      user.destroy
    end
  end

end