require 'test_helper'
include Devise::TestHelpers

class DashboardControllerTest < ActionController::TestCase
  
  test "should get show if no announcement" do
    sign_in users(:one)
    get :show
    assert_response :sucess
    assert_template 'show'
  end
  
end
