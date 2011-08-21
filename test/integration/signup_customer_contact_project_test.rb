require 'test_helper'

class SignupCustomerContactProjectTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should signup" do
    get register_path
    assert_response :redirect
    follow_redirect!
    
    post new_user_session_path, :email => "a@gmail.com", :password => '123456', :first_name => 'W', :last_name => 'S'
    assert_response :success
    assert_redirected_to root_path
    follow_redirect!
    
  end
  
end
