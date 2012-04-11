# encoding: utf-8
require "spec_helper"

describe Mailchimp::Base do

  context "load file configuration" do
    context "for existing config file" do
      before do
        YAML.stub!(:load_file).with(Rails.root + "config/mailchimp.yml").and_return(
                {"test" => {"enabled" => true, "api_key" => "test token", "list_id" => "test list"}}
        )
        Mailchimp::Base.load_config
      end

      it "should return correct config data" do
        Mailchimp.config.should == {:enabled => true, :api_key => "test token", :list_id => "test list"}
      end

      it "should be enabled" do
        Mailchimp.should be_enabled
      end
    end

    context "without config file" do
      before do
        #YAML.stub!(:load_file).with(Rails.root + "config/mailchimp.yml").and_raise(ArgumentError)
        YAML.stub!(:load_file).and_raise(ArgumentError)
        Mailchimp::Base.load_config
      end

      it "should return empty config" do
        Mailchimp.config.should == {}
      end

      it "should be disabled" do
        Mailchimp.should_not be_enabled
      end
    end
  end
end  