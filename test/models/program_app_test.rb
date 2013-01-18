require 'minitest_helper'

class ProgramAppTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  FACEBOOK_APP_ID = "268106776622761"
  FACEBOOK_APP_SECRET = "359fc8b54f27391cb96a06845cbfe77b"
  GOOGLE_ANALYTICS_TRACKING_CODE = "UA-23717911-32"

  def setup
    @program_app = build(:program_app)
    # @program_app = ProgramApp.new(name: "Test App")
    # @program_app.program_id = 1
  end

  test "should not save without name" do
    @program_app.name = nil
    refute @program_app.save, "Saved without a name"
  end

  test "should not save if facebook_app_id is over 30 characters long" do
    @program_app.facebook_app_id = '1' * 31
    refute @program_app.save, "Saved with a facebook_app_id over 30 characters long"
  end

  test "should not save if facebook_app_secret is over 60 characters long" do
    @program_app.facebook_app_secret = '1' * 61
    refute @program_app.save, "Saved with a facebook_app_secret over 60 characters long"
  end

  test "should not save if facebook_app_id does not authenticate with facebook_app_secret" do
    stub_facebook_access_token_request

    @program_app.facebook_app_id = FACEBOOK_APP_ID
    @program_app.facebook_app_secret = FACEBOOK_APP_SECRET
    refute @program_app.save, "Saved when facebook_app_id and facebook_app_secret did not authenticate"
  end

  test "should not save if either facebook_app_id or facebook_app_secret is missing" do
    @program_app.facebook_app_id = FACEBOOK_APP_ID
    refute @program_app.save, "Saved with facebook_app_secret missing"

    @program_app.facebook_app_id = nil
    @program_app.facebook_app_secret = FACEBOOK_APP_SECRET
    refute @program_app.save, "Saved with facebook_app_id missing"
  end

  test "should not save if google_analytics_tracking_code is over 20 characters long" do
    @program_app.google_analytics_tracking_code = 'a' * 21
    refute @program_app.save, "Saved with google_analytics_tracking_code over 20 characters long"
  end

  test "should not save if google_analytics_tracking_code is incorrectly formatted" do
    @program_app.google_analytics_tracking_code = "UA-AAAAA"
    refute @program_app.save, "Saved with google_analytics_tracking_code incorrectly formatted"
  end

  test "should save if google_analytics_tracking_code is correctly formatted and 20 characters or less" do
    @program_app.google_analytics_tracking_code = GOOGLE_ANALYTICS_TRACKING_CODE
    assert @program_app.save, "Did not save with correctly formatted google_analytics_tracking_code"
  end

  test "object_label should truncate the name to no longer than 25 characters" do
    @program_app.name = "This Name is Over Twenty-Five Characters Long"
    assert @program_app.object_label.length <= 25 && @program_app.object_label.length > 0
  end

  def stub_facebook_access_token_request
    stub_request(:post, "https://graph.facebook.com/oauth/access_token").to_return do |request|
      if !(request.body =~ /client_id=268106776622761/).nil? && !(request.body =~ /client_secret=359fc8b54f27391cb96a06845cbfe77a/).nil?
        res = {:status => 200, :body => "268106776622761|GKVDPZqlxEFZ1qg01aezXva8ws0"}
      else
        res = {:status => 400, :body => "{\"error\":{\"message\":\"Error validating client secret.\",\"type\":\"OAuthException\",\"code\":1}}"}
      end
      res
    end
  end
end