require "spec_helper"

describe "User (model)" do

  describe "#subscribe" do
    let!(:user){ create(:unsubscribed_user) }

    specify { Mailchimp::User.should_not_receive(:subscribe) }

    it "should call subscribe method" do
      pending
      Mailchimp::User.should_receive(:subscribe)
      user.subscribe!
    end
  end

  describe "#unsubscribe" do
    let!(:user){ create(:subscribed_user) }

    specify { Mailchimp::User.should_not_receive(:unsubscribe) }

    it "should call subscribe method" do
      Mailchimp::User.should_receive(:unsubscribe)
      user.unsubscribe!
    end
  end

end
