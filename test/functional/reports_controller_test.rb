require 'test_helper'
include Devise::TestHelpers

class ReportsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @report = reports(:one)
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should create report" do
    assert_difference('Report.count') do
      post :create, :report => @report.attributes
    end

    assert_redirected_to report_path(assigns(:report))
  end

  test "should show report" do
    get :show, :id => @report.to_param
    assert_response :success
    assert_template 'show'
  end
end
