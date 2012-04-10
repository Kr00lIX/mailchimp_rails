require "spec_helper"

describe "Mailchimp::WebHooks" do

  it "should correct responce with blank action" do
    visit mailchimp_hooks_path
    page.driver.response.status.should == 200
    page.should have_content("blank action")
  end

  describe "unsubscribe action" do
    let!(:user) { create(:user) }

    it "should mark usubscribed user" do
      Mailchimp::WebHook.should_receive(:unsubscribe).with("email" => user.email)

      visit mailchimp_hooks_path(:type => "unsubscribe", :data => {:email => user.email})
      page.should have_content("ok")
    end
  end

  %w(subscribe upemail profile cleaned).each do |action|
    describe "#{action} action" do
      it "should return not emplimented error" do
        expect do
          visit mailchimp_hooks_path(type: action)
        end.to raise_error(Mailchimp::NotEmplementedError)
      end
    end
  end

end