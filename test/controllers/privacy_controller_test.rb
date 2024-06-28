require "test_helper"

class PrivacyControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get privacy_show_url
    assert_response :success
  end
end
