require 'test_helper'
include Devise::TestHelpers

class DashboardControllerTest < ActionController::TestCase
  
  test "should get show" do
    sign_in users(:one)
    get :show
    assert_response :success
  end
  
end
