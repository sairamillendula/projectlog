require 'test_helper'

class Administr8te::LogsControllerTest < ActionController::TestCase
  test "should not get show if not admin" do
    sign_in users(:two)
    get :show
    assert_response :redirect
  end
  
  setup do
    sign_in users(:one)
  end

  test "should get show" do
    get :show
    assert_response :success
    assert_template 'show'
  end
end
