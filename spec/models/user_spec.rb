# encoding: utf-8
require 'spec_helper'

describe User do

  describe "when app has plugin loaded" do
    it "should respond to the plugin class method" do
      ActiveRecord::Base.should respond_to(:mailchimp_user)
    end

    it "User should respond_to .authenticates_with_sorcery!" do
      User.should respond_to(:mailchimp_user)
    end
  end

  describe User, "user configuration" do
    subject{ User.new(email: "example@example.com", first_name: "William", last_name: "Shakespeare") }

    it "should has static valid config" do
      subject.mailchimp_data.should == {EMAIL:"example@example.com", NAME: "William Shakespeare"}
    end

    it "should has update_mailchimp method" do
      Mailchimp::User.should_receive(:update).with(subject)
      subject.update_mailchimp
    end
  end

end