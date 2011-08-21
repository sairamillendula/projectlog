require 'test_helper'

class RegisterLogoutTest < ActionDispatch::IntegrationTest
  fixtures :all

    test "should signup" do
      https!
      get register_path
      assert_response :success

      post new_user_session_path, :email => "a@gmail.com", :password => '123456', :first_name => 'W', :last_name => 'S'
      assert_response :success
    end

    test "should logout" do
      https!
      get logout_path
      assert_response :redirect

      assert_redirected_to login_path
      follow_redirect!
    end
  
end
