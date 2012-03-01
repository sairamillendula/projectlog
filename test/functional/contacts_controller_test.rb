require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @contact = contacts(:one)
    @customer = @contact.customer
  end

  test "should get index" do
    get :index, :customer_id => @customer.to_param
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new, :customer_id => @customer.to_param
    assert_response :success
    assert_template 'new'
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, :contact => @contact.attributes.except("id", "created_at", "updated_at"), :customer_id => @customer.to_param
    end

    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should show contact" do
    get :show, :id => @contact.to_param, :customer_id => @customer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @contact.to_param, :customer_id => @customer.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update contact" do
    put :update, :id => @contact.to_param, :contact => @contact.attributes.except("id", "created_at", "updated_at"), :customer_id => @customer.to_param
    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, :id => @contact.to_param, :customer_id => @customer.to_param
    end

    assert_redirected_to customer_path(assigns(:customer))
  end
end
