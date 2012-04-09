describe "WebHooks" do

  describe "delegate routing method" do
    it "should exist routes method" do
      Mailchimp.routes.should be_a(Proc)
    end
  end

end