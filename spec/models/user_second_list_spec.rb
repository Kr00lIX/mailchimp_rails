# encoding: utf-8
require 'spec_helper'

describe User, "(second list)" do

  let!(:second_list) { :second }

  describe User, "user configuration" do
    subject { User.new(email: "example@example.com", first_name: "William") }

    it "should has static valid config" do
      subject.mailchimp_data(second_list).should == {EMAIL: "example@example.com", TITLE: "William title "}
    end
  end

  describe ".update and .subscribe" do
    before do
      Mailchimp::Base.stub!(:enabled? => true, :config => {:second_list_id => "second_list_token"})
    end

    specify "should be enabled" do
      Mailchimp.should be_enabled
    end

    specify { Mailchimp.config.should == {:second_list_id => "second_list_token"} }

    describe "skip user states restriction for second list" do

      it "should allow run subscribe for unsubscribed user" do
        user = build(:unsubscribed_user)
        Mailchimp::Base.hominid.should_receive(:list_subscribe).
                with(anything, user.email, {:EMAIL => user.email, :TITLE => user.title}, 'html', boolean, boolean, boolean, boolean)

        Mailchimp::User.subscribe(user, :list => second_list)
      end

      it "should call update for unsubscribed user" do
        user = build(:unsubscribed_user)
        Mailchimp::Base.hominid.should_receive(:list_update_member).
                with(anything, user.email, {:EMAIL => user.email, :TITLE => user.title}, 'html', boolean)

        Mailchimp::User.update(user, :list => second_list)
      end

      it "should call update for disabled user" do
        user = build(:subscribed_error_user)
        Mailchimp::Base.hominid.should_receive(:list_update_member).
                with(anything, user.email, {:EMAIL => user.email, :TITLE => user.title}, 'html', boolean)

        Mailchimp::User.update(user, :list => second_list)
      end
    end

  end

  describe ".update_all_lists" do
    before do
      Mailchimp::Base.stub!(:enabled? => true)
    end

    let(:user) { build(:subscribed_user) }

    it "should call update for disabled user" do
      Mailchimp::Base.hominid.should_receive(:list_update_member).
              with(anything, user.email, {:EMAIL => user.email, :NAME => user.full_name}, anything, boolean)
      Mailchimp::Base.hominid.should_receive(:list_update_member).
              with(anything, user.email, {:EMAIL => user.email, :TITLE => user.title}, anything, boolean)

      Mailchimp::User.update_all_lists(user)
    end
  end

end