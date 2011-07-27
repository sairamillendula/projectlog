require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  test "should not save without first and last name" do
    contact = Contact.new
    assert !contact.valid?
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
  
  test "should get index" do
    contacts = Contact.all
    assert_not_nil(id)
  end
  
  test "should create contact" do
    customer = Customer.find(:one)
    contact = @customer.contact.new(:one)
    contact.update_attributes(:first_name => 'First Name Test', :last_name => 'Last Name Test')
    assert contact.save
  end
  
  test "should find contact" do
    contact_id = customers(:one).id
    assert_nothing_raised { Contact.find(contact_id) }
  end
  
  test "should show contact" do
    get :show, :id => @contact.to_param
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:contact)
    assert assigns(:contact).valid?
  end  

  test "should update contact" do
    contact = customers(:one)
    assert contact.update_attributes(:email => 'test@test.com')
  end

  test "should destroy contact" do
    contact = customers(:one)
    contact.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Contact.find(contact.id) }
  end
  
end
