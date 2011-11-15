require 'test_helper'

class PaymentTest < ActiveSupport::TestCase

  test "should create payment" do
    payment = invoices(:one).payments.new
    payment.date = Time.now
    payment.amount = '100.05'
    assert payment.save!
  end

  test "should not save without required fields" do
    payment = invoices(:one).payments.new
    assert !payment.valid?
    assert = payment.errors[:date].any?
    assert = payment.errors[:amount].any?
    assert_equal ["can't be blank"], payment.errors[:date]
    assert_equal ["can't be blank", "is not a number"], payment.errors[:amount]
  end
  
  test "should not create payment greater than balance" do
    payment = invoices(:one).payments.new
    payment.date = Time.now
    payment.amount = '200'
    assert !payment.valid?
    assert = payment.errors[:amount].any?
    assert_equal ["must be less than or equal to 150.0"], payment.errors[:amount]
  end
  
  test "should find payment" do
    payment_id = payments(:one).id
    assert_nothing_raised { Payment.find(payment_id) }
  end

  test "should update payment" do
    payment = invoices(:one).payments.first
    assert payment.update_attributes(:amount => '120')
  end

  test "should destroy payment" do
    payment = payments(:one)
    payment.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Payment.find(payment.id) }
  end

end