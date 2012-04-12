# encoding: utf-8
require "spec_helper"

describe MailchimpUserObserver do

  let(:user){ build(:user) }

  describe "#create" do
    it "should subscribe if user want mail" do
      pending
      Mailchimp::User.should_receive(:subscribe).with(user)
      user.save
    end

    it "should not subscribe if it doesn't want email" do
      Mailchimp::User.should_not_receive(:subscribe)
      user.save
    end
  end

  describe "#update" do
    before do
      user.save
    end

    it "should call update method" do
      Mailchimp::User.should_not_receive(:subscribe)
      Mailchimp::User.should_receive(:update).with(user).any_number_of_times

      user.update_attributes(:email => "new_email@example.com")
    end
  end

  describe "#destroy" do
    before do
      user.save
    end

    it "should unsubscribe user" do
      pending
      Mailchimp::User.should_receive(:unsubscribe).with(user.email)
      user.destroy
    end
  end

end