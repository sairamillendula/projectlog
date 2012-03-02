require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @customer = customers(:one)
    @customer_with_invoice = customers(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customers)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post :create, :customer => @customer.attributes.except("id", "created_at", "updated_at").merge(:name => "#{@customer.name} Jr.")
    end

    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should show customer" do
    get :show, :id => @customer.to_param
    assert_response :success
    assert_template 'show'
  end

  test "should get edit" do
    get :edit, :id => @customer.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update customer" do
    put :update, :id => @customer.to_param, :customer => @customer.attributes.except("id", "created_at", "updated_at")
    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should destroy customer" do
    @customer.projects = [] # A customer can't be deleted if it has associated projects
    @customer.save!
    assert_difference('Customer.count', -1) do
      delete :destroy, :id => @customer.to_param
    end

    assert_redirected_to customers_path
  end

  test "should not destroy customer with invoices" do
    delete :destroy, :id => @customer_with_invoice.to_param
    assert_equal 'This customer cannot be deleted because of existing projects/invoices associated', flash[:alert]
  end
end