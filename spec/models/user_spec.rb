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
    subject { User.new(email: "example@example.com", first_name: "William", last_name: "Shakespeare") }

    it "should has static valid config" do
      subject.mailchimp_data.should == {EMAIL: "example@example.com", NAME: "William Shakespeare"}
    end

    it "should has update_mailchimp method" do
      Mailchimp::User.should_receive(:update).with(subject)
      subject.update_mailchimp
    end
  end

  describe ".update" do
    before do
      Mailchimp::Base.stub!(:enabled? => true)
    end

    specify "should be enabled" do
      Mailchimp.should be_enabled
    end

    describe "user status restriction" do
      after do
        Mailchimp::User.update(@user)
      end

      it "should allow run update for subscribed user" do
        Mailchimp::Base.hominid.should_receive(:listUpdateMember)

        @user = build(:subscribed_user)
      end

      it "should not call update for unsubscribed user" do
        Mailchimp::Base.hominid.should_not_receive(:listUpdateMember)

        @user = build(:unsubscribed_user)
      end

      it "should not call update for disabled user" do
        Mailchimp::Base.hominid.should_not_receive(:listUpdateMember)

        @user = build(:subscribed_error_user)
      end
    end

    describe "arguments validation" do
      it "should rise error if call without user arg" do
        expect {
          Mailchimp::User.update(nil)
        }.to raise_error(ArgumentError)
      end

      it "should call update for unsubscribed user if validation is false" do
        Mailchimp::Base.hominid.should_receive(:listUpdateMember)

        user = build(:unsubscribed_user)
        Mailchimp::User.update(user, :validate => false)
      end

      it "should allow receive change user and list_id params"
    end

    describe "mailchimp error codes" do
      let(:user) { build(:subscribed_user) }

      it "should call subscribe for 'There is no record in the database'" do
        error = mock :faultCode => 232, :message => %Q(There is no record of "#{user.email}" in the database)
        Mailchimp::Base.hominid.stub!(:listUpdateMember).and_raise(Hominid::APIError.new(error))
        Mailchimp::Base.hominid.should_receive(:list_subscribe)
        Mailchimp::User.update(user)
      end

      it "should raise error for 'email address does not belong to this list'" do
        error = mock :faultCode => 215, :message => %Q(There is no record of "#{user.email}" in the database)
        Mailchimp::Base.hominid.stub!(:listUpdateMember).and_raise(::Hominid::APIError.new(error))

        expect {
          Mailchimp::User.update(user)
        }.to raise_error(Hominid::APIError)
      end
    end
  end
end