require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should get show if no announcement" do
    sign_in users(:one)
    get :show
    assert_response :success
    assert_template 'show'
  end

end
