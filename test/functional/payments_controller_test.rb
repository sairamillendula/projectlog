require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @invoice = invoices(:one)
    @payment = invoices(:one).payments.first
  end

  test "should get index" do
    get :index, invoice_id: @invoice.slug, format: "js"
    assert_response :success
    assert_not_nil assigns(:invoice)
    assert_not_nil assigns(:payments)
    assert_equal assigns(:total), assigns(:payments).map(&:amount).sum.round(2)
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, invoice_id: @invoice.slug, payment: @payment.attributes, format: "js"
    end
    assert_response :success
    assert_not_nil assigns(:invoice)
    assert_not_nil assigns(:payment)
  end

  test "should get edit" do
    get :edit, invoice_id: @invoice.slug, id: @payment.to_param, format: "js"
    assert_response :success
    assert_not_nil assigns(:invoice)
    assert_not_nil assigns(:payment)
  end

  test "should update payment" do
    put :update, invoice_id: @invoice.slug, id: @payment.to_param, payment: @payment.attributes, format: "js"
    assert_response :success
    assert_not_nil assigns(:invoice)
    assert_not_nil assigns(:payment)
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, invoice_id: @invoice.slug, id: @payment.to_param, format: "js"
    end
    assert_response :success
    assert_not_nil assigns(:invoice)
  end
end
