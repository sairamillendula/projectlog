require 'test_helper'

class SignupCustomerContactProjectTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should signup" do
    get register_path
    assert_response :redirect
    follow_redirect!
    
    user = users(:two)
    user.email = "user-two@example.com"

    post_via_redirect user_registration_path, user: {first_name: user.first_name, last_name: user.last_name, email: user.email, password: "123456", password_confirmation: "123456"}
    assert_response :success

    post_via_redirect new_user_session_path, user: {email: user.email, password: "123456", remember_me: "0"}
    assert_response :success

    get_via_redirect root_path
    assert_response :success

    get new_customer_path
    assert_response :success
    assert_template 'new'

    post_via_redirect customers_path, :customer => {:name => 'Apple', :country => 'France'}
    
    assert assigns(:customer).valid?
    assert_response :success
    assert_template :show

    get new_customer_contact_path(assigns(:customer))
    assert_response :success
    assert_template 'new'
    
    post "/customers/#{assigns(:customer).id}/contacts", :contact => {:first_name => 'John'}
    
    assert assigns(:contact).valid?
    assert_response :redirect
    assert_redirected_to customer_path(assigns(:customer))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show

    get new_project_path
    assert_response :success
    assert_template 'new'
    
    post projects_path, :project => projects(:open_and_billable).attributes.merge(:title => "#{projects(:open_and_billable).title} 2").reject {|k, v| ["id", "user_id", "created_at", "updted_at"].include? k }
    
    assert assigns(:project).valid?
    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show
  end
  
end
