require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  test "should create customer" do
    customer = users(:one).customers.new
    customer.name = 'Apple'
    assert customer.save
  end
  
  test "should not save without a name" do
    customer = Customer.new
    assert !customer.valid?
    assert customer.errors[:name].any?
    assert_equal ["can't be blank"], customer.errors[:name]
    assert !customer.save
  end

  test "Ensure name is unique" do
    customer2 = users(:one).customers.create(:name => 'Customer 2' )
    assert !customer2.valid?
    assert customer2.errors[:name].any?
    assert_equal ["has already been taken"], customer2.errors[:name]
    assert !customer2.save
  end
 
  test "should not save without user_id" do
    user = users(:one)
    customer = user.customers.new
    customer.name = "Customer Test"
    assert_not_nil(customer.user_id) 
    assert customer.save
  end
  
  test "should find customer" do
    customer_id = customers(:one).id
    assert_nothing_raised { Customer.find(customer_id) }
  end

  test "should update customer" do
    customer = customers(:one)
    assert customer.update_attributes(:name => 'New name')
  end

  test "should destroy customer and contacts" do
    customer = customers(:one)
    customer.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Customer.find(customer.id) }
    assert !customer.contacts.any?
  end
  
end
