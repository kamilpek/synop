require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get admin_main_url
    assert_response :success
  end

  test "should get users" do
    get admin_users_url
    assert_response :success
  end

end
