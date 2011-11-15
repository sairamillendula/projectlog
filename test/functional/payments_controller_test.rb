require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @invoice = invoices(:one)
    @payment = invoices(:one).payments.first
  end

  test "should get index" do
  end

  test "should get new" do
  end

  test "should create payment" do
  end

  test "should get edit" do
  end

  test "should update payment" do
  end

  test "should destroy payment" do
  end
end
