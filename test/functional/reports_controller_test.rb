require 'test_helper'

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

  test "should get PDF" do
    get :shared, :id => @report.to_param, :format => :pdf
    assert_response :success
    assert_template 'shared'
  end

  test "should get csv" do
    get :shared, :id => @report.to_param, :format => :csv
    assert_response :success
    assert_template 'shared'
  end

  test "shared report should be accessible to all" do
    sign_out users(:one)
    get :shared, :id => @report.to_param
    assert_response :success
    assert_template 'shared'
  end

end
