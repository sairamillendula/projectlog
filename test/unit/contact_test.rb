require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  test "should create contact" do
    contact = customers(:one).contacts.new
    contact.first_name = 'Jean'
    assert contact.save
  end
  
  test "should not save without first and last name" do
    contact = Contact.new
    assert !contact.valid?
    assert contact.errors[:first_name].any?
    assert_equal ["can't be blank"], contact.errors[:first_name]
    assert !contact.save
  end
 
  test "should not save without customer_id" do
    customer = customers(:one)
    contact = customer.contacts.new
    contact.first_name = "Test First Name"
    contact.last_name = "Test Last Name"
    assert_not_nil(contact.customer_id) 
    assert contact.save
  end
  
  test "should find contact" do
    contact_id = customers(:one).id
    assert_nothing_raised { Contact.find(contact_id) }
  end

  test "should update contact" do
    contact = customers(:one)
    assert contact.update_attributes(:email => 'test@test.com')
  end

  test "should destroy contact" do
    contact = contacts(:one)
    contact.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Contact.find(contact.id) }
  end
  
end
