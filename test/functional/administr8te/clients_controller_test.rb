require 'test_helper'

class Administr8te::ClientsControllerTest < ActionController::TestCase
  test "should not get index if not admin" do
    sign_in users(:two)
    get :index
    assert_response :redirect
  end
  
  setup do
    sign_in users(:one)
    @client = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_template 'index'
  end
  
end
