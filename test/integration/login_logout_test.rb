require 'test_helper'
include Devise::TestHelpers

class LoginLogoutTest < ActionDispatch::IntegrationTest
  fixtures :users
  fixtures :announcements
    
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
    
    test "should logout" do
      https!
      get logout_path
      assert_response :redirect
    
      assert_redirected_to login_path
      assert_nil session[:user]
    end
    
    test "should redirect to announcement after login if there's one pending" do
      user = users(:one)
      announcement = Announcement.current_announcement_for(user)
      assert announcement, "there's not a pending announcement"
      
      https!
      get "/user/login"
      assert_response :success
      
      post user_session_path, :user => { :email => user.email, :password => "123456", :remember_me => "0" }
      assert_redirected_to announcement_path(announcement)
    end
    
end
