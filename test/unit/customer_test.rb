require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  test "should not save without a name" do
    customer = Customer.new
    assert !customer.valid?
    assert !customer.save
  end

  test "should not save without a unique name" do
    customer = Customer.new
    customer.name = "Testing Customer"
    customer.save
    assert customer.save
    customer2 = Customer.new
    customer2.name = "Testing Customer"
    customer2.save
    assert !customer2.save, "Customer name is not unique"
  end
 
  test "should not save without user_id" do
    user = users(:one)
    customer = user.customers.new
    customer.name = "Customer Test"
    assert_not_nil(customer.user_id) 
    assert customer.save
  end
  
  test "should get index" do
    customers = Customer.all
    assert_not_nil(id)
  end
  
  test "should create customer" do
    customer = Customer.new(:one)
    customer.update_attributes(:name => 'Customer Test')
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

  test "should destroy customer" do
    customer = customers(:one)
    customer.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Customer.find(customer.id) }
  end
  
end
