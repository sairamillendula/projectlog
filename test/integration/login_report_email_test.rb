require 'test_helper'
include Devise::TestHelpers

class LoginReportEmailTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should login, create a report, send by email" do
    https!
    get login_path
    assert_response :success

    post_via_redirect new_user_session_path, user: {email: users(:one).email, password: "123456", remember_me: "0"}
    assert_response :success
    
    get new_report_path
    assert_response :success
    
    post reports_path, :report => { :start_date => 2.months.ago, :end_date => Time.now }
    
    assert assigns(:report).valid?
    assert_response :redirect
    assert_redirected_to report_path(assigns(:report))
    
    get "/reports/#{assigns(:report).slug}/emails/new"
    assert_response :success
    
    post "/reports/#{assigns(:report).slug}/emails", :format => "js", :reports_email => { :to => 'joe@email.com', :from => users(:one).email, :subject => 'Test report email', :body =>  'Hi this is a test: link-to-report', :report_link => "link-to-report", :reply_to => users(:one).email}
    assert assigns(:email).valid?
    assert_response :success
  end
  
end
