require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: @invoice.attributes.except("id", "created_at", "updated_at", "slug")
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice.to_param
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice.to_param, invoice: @invoice.attributes.except("id", "created_at", "updated_at", "slug")
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice.to_param
    end

    assert_redirected_to invoices_path
  end

  test "should send invoice to client with attach" do
    contact = contacts(:three)
    post :send_email, format: :js, id: @invoice.to_param, send_invoice: { subject: "Invoice for bla-bla", body: "See invoice attached", to: contact.email, attach: "1"}
    assert_response :success
  end

end
