require 'test_helper'
include Devise::TestHelpers

class CreateCustomerContactProjectTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "login, create a customer, add contacts and creates a project" do
    https!
    get login_path
    assert_response :success

    post_via_redirect new_user_session_path, user: {email: users(:one).email, password: "123456", remember_me: "0"}
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
    
    post projects_path, :project => projects(:open_and_billable).attributes.merge(:title => "#{projects(:open_and_billable).title} 2").reject {|k, v| ["id", "user_id", "created_at", "updated_at"].include? k }
    
    assert assigns(:project).valid?
    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show
  end
  
end
