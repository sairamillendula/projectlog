require 'test_helper'
include Devise::TestHelpers

class CreateCustomerContactProjectTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "login, create a customer, add contacts and creates a project" do
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
    
  test "create a customer" do
    get new_customer_path
    assert_response :redirect
    assert_template 'new'
    
    post customers_path, :customer => {:name => 'Apple', :country => 'France'}
    
    assert assigns(:customer).valid?
    assert_response :redirect
    assert_redirected_to customer_path(assigns(:customer))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show  
  end
   
  test "add contact to customer" do
    get new_contact_path(assigns(:customer))
    assert_response :redirect
    assert_template 'new'
    
    post customer_contact_path, :contact => {:first_name => 'John'}
    
    assert assigns(:contact).valid?
    assert_response :redirect
    assert_redirected_to customer_path(assigns(:customer))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show
  end
  
  test "add project" do
    get new_project_path
    assert_response :redirect
    assert_template 'new'
    
    post projects_path, :project => projects(:open_and_billable)
    
    assert assigns(:project).valid?
    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
    
    follow_redirect!
    
    assert_response :success
    assert_template :show
  end
  
end