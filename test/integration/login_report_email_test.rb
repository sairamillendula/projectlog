require 'test_helper'
include Devise::TestHelpers

class LoginReportEmailTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should login" do
    https!
    get login_path
    assert_response :success
  
    sign_in users(:one)
    assert_response :success
    
    post "/user"
    assert_response :success
          
    get_via_redirect root_path
    assert_response :success
  end
  
  test "create a report, send by email" do
    
    get new_report_path
    assert_response :redirect 
    
    post reports_path, :report => { :start_date => 2.months.ago, :end_date => Time.now }
    
    assert assigns(:report).valid?
    assert_response :redirect
    assert_redirected_to report_path(assigns(:report))
    
    get new_report_email_path
    assert_response :redirect
    
    post report_emails_path, :email => { :to => 'joe@email.com', :from => 'user@email.com', :subject => 'Test report email', 
                                       :body =>  'Hi this is a test', :report_slug => 'dfdkokpaedmxoz' }
    assert_response :success
  end
  
end
