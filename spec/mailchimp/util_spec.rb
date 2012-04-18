require "spec_helper"

describe Mailchimp::Util do

  describe ".prepare_array" do
    it "should join all elements when all elements is a string" do
      Mailchimp::Util.prepare_array(["first", "second", "third"]).should == "first, second, third"
    end

    it "should return same array if one element is not a string" do
      Mailchimp::Util.prepare_array(["first", 2, "third"]).should == ["first", 2, "third"]
    end

    it "should return same array if one element is a hash" do
      Mailchimp::Util.prepare_array([{:a=>"a1"}, {:a => "a2"}]).should == [{:a => "a1"}, {:a => "a2"}]
    end
  end

  describe ".sanitize_string" do
    it "should escape commas" do
      Mailchimp::Util.sanitize_string(%q('""')).should == "'\"\"'"
    end
  end

  describe ".prepare_bool" do
    it "should return 1 for true" do
      Mailchimp::Util.prepare_bool(true).should == 1
    end

    it "should return 0 for false" do
      Mailchimp::Util.prepare_bool(false).should == 0
    end
  end

  describe ".prepare_params" do
    it "should return prepared hash" do
      raw_params = {:bool_true => true, :nil_param => nil, :array1 => %w(a b), :array2 => %w(a'a b"b c,c)}
      params = Mailchimp::Util.prepare_params(raw_params)

      params[:bool_true].should == 1
      params[:nil_param].should == ""
      params[:array1].should == "a, b"
      params[:array2].should == "a'a, b\"b, c,c"
    end
  end

  describe ".prepare_group" do
    it "should return prepared hash" do
      raw_params = ["13. Photostory", "15. Raw", "26. Vibiraem Objektiv"]
      Mailchimp::Util.prepare_group(raw_params).should == "13. Photostory,15. Raw,26. Vibiraem Objektiv"
    end
  end

end