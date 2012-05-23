require "spec_helper"

describe Mailchimp::Util do

  describe ".prepare_array" do
    it "should join all elements when all elements is a string" do
      Mailchimp::Util.prepare_array(["first", "second", "third"]).should == "first, second, third"
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
    before do
      @params = {:bool_true => true, :nil_param => nil, :array1 => %w(a b), :array2 => %w(a'a b"b c,c), :GROUPINGS => []}
    end
    subject { Mailchimp::Util.prepare_params(@params) }

    its([:bool_true]) { should == 1 }
    its([:nil_param]) { should == "" }
    its([:array1]) { should == "a, b" }
    its([:array2]) { should == "a'a, b\"b, c,c" }
    its([:GROUPINGS]) { should == [] }

    describe "sanitaze group data " do
      before do
        @params = {
          :param1 => "first param",
          :GROUPINGS => [
            {:name => 'first " group', :groups => "1. first title,2. second title,4. another title"},
            {:name => "second ' group", :groups => ["12, first title", "13, second title", "18, another title"]}
          ]
        }
      end

      it "should return prepared params" do
        subject[:GROUPINGS].tap do |group_params|
          group_params[0][:name].should == "first \" group"
          group_params[0][:groups].should == "1. first title,2. second title,4. another title"

          group_params[1][:name].should == "second ' group"
          group_params[1][:groups].should == "12\\, first title,13\\, second title,18\\, another title"
        end

        subject[:param1].should == "first param"
      end

    end
  end

  describe ".prepare_group_array" do
    it "should return prepared hash" do
      raw_params = ["13. Photostory", "15. Raw", "26. Vibiraem Objektiv"]
      Mailchimp::Util.prepare_group_array(raw_params).should == "13. Photostory,15. Raw,26. Vibiraem Objektiv"
    end
  end

end