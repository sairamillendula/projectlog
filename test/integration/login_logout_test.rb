require 'test_helper'
include Devise::TestHelpers

class LoginLogoutTest < ActionDispatch::IntegrationTest
  fixtures :users
    
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
    
end
