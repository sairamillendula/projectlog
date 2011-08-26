require 'test_helper'

class RegisterLogoutTest < ActionDispatch::IntegrationTest
  fixtures :users
  user = users(:one)

    test "should signup" do
      https!
      get register_path
      assert_response :success

      post new_user_session_path, :email => user.email, :password => user.password, 
                                  :first_name => user.first_name, :last_name => user.last_name
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
