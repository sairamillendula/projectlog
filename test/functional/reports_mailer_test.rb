require 'test_helper'
include Devise::TestHelpers

class ReportsMailerTest < ActionMailer::TestCase
  setup do
    sign_in users(:one)
    @report = reports(:one)
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should send report by email" do
    assert_difference('Report.count') do
      post :create, :report => @report.attributes
    end

    assert_redirected_to report_path(assigns(:report))
  end
end
