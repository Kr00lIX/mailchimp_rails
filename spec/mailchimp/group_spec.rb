# encoding: utf-8
require "spec_helper"

describe Mailchimp::Group do
  before do
    Mailchimp::Base.stub!(:enabled? => true)
  end

  it "should call hominid method with valid param" do
    list_id, group_name, group_id = "list token", "example group", "group token"

    Mailchimp::Base.hominid.should_receive(:list_interest_group_add).with(list_id, group_name, group_id)

    Mailchimp::Group.add(group_name, :list_id => list_id, :group_id => group_id)
  end

end

