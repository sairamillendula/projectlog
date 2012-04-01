require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  
  test "should create invoice" do
    invoice = invoices(:one)
    assert invoice.save
  end
  
  test "should not save without subject, status, customer, due_date, issued_date and currency" do
    invoice = users(:one).invoices.new
    assert !invoice.valid?
    assert invoice.errors[:subject].any?
    assert invoice.errors[:status].any?
    assert invoice.errors[:customer].any?
    assert invoice.errors[:due_date].any?
    assert invoice.errors[:issued_date].any?
    assert invoice.errors[:currency].any?
    assert_equal ["can't be blank"], invoice.errors[:subject]
    assert_equal ["can't be blank"], invoice.errors[:status]
    assert_equal ["can't be blank"], invoice.errors[:customer]
    assert_equal ["can't be blank"], invoice.errors[:due_date]
    assert_equal ["can't be blank"], invoice.errors[:issued_date]
    assert_equal ["can't be blank"], invoice.errors[:currency]
    assert !invoice.save
  end

  test "should not save without user_id" do
    user = users(:one)
    invoice = user.invoices.new
    inv = invoices(:one)
    invoice.subject = inv.subject
    invoice.status = inv.status
    invoice.customer = inv.customer
    invoice.due_date = inv.due_date
    invoice.issued_date = inv.issued_date
    invoice.currency = inv.currency
    assert_not_nil(invoice.user_id)
    assert invoice.save
  end
  
  test "should find invoice by slug" do
    slug = invoices(:one).slug
    assert_nothing_raised { Invoice.find_by_slug(slug) }
  end

  test "should update invoice" do
    invoice = invoices(:one)
    assert invoice.update_attributes(:subject => 'New subject')
  end

  test "should destroy invoice, line items and payments" do
    invoice = invoices(:one)
    invoice.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Invoice.find(invoice.id) }
    assert !invoice.line_items.any?
    assert !invoice.payments.any?
  end
  
  test "tax 1 amount" do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10 # 10%
    invoice.stubs(:subtotal).returns(50)
    assert_equal 5, invoice.tax1_amount
  end
  
  test "tax 2 amount" do
    invoice = users(:one).invoices.new
    invoice.tax2 = 5 # 50%
    invoice.stubs(:subtotal).returns(50)
    assert_equal 2.5, invoice.tax2_amount
  end
  
  test "discount amount" do
    invoice = users(:one).invoices.new
    invoice.discount = 5 # 5%
    invoice.stubs(:subtotal).returns(50)
    assert_equal 2.5, invoice.discount_amount
  end
  
  test "amount due with discount and no tax" do
    invoice = users(:one).invoices.new
    invoice.discount = 5
    invoice.stubs(:subtotal).returns(50)
    assert_equal 47.5, invoice.amount_due
  end
  
  test "amount due with discount and tax 1" do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10
    invoice.discount = 5
    invoice.stubs(:subtotal).returns(50)
    assert_equal 52.5, invoice.amount_due
  end
  
  test "amount due with discount and tax 2" do
    invoice = users(:one).invoices.new
    invoice.tax2 = 5
    invoice.discount = 5
    invoice.stubs(:subtotal).returns(50)
    assert_equal 50, invoice.amount_due
  end
  
  test "amount due with discount and all taxes" do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10
    invoice.tax2 = 5
    invoice.discount = 5
    invoice.stubs(:subtotal).returns(50)
    assert_equal 55, invoice.amount_due
  end
  
  test "amount due with discount and all taxes and compound" do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10
    invoice.tax2 = 5
    invoice.compound = true
    invoice.discount = 5
    invoice.stubs(:subtotal).returns(50)
    assert_equal 55.25, invoice.amount_due
  end
  
  test 'taxable tax name' do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10
    invoice.tax1_label = "Personal"
    invoice.tax2 = 5
    assert invoice.any_taxes?
    assert_equal "Personal (10.0%)", invoice.tax1_name
    assert_equal "Tax 2 (5.0%)", invoice.tax2_name
  end
  
  test 'should has any taxes if tax1 present' do
    invoice = users(:one).invoices.new
    invoice.tax1 = 10
    invoice.tax1_label = nil
    invoice.tax2 = ""
    invoice.tax2_label = nil
    invoice.compound = true
    assert invoice.any_taxes?
  end
  
  test 'should has any taxes if tax2 present' do
    invoice = users(:one).invoices.new
    invoice.tax1 = ""
    invoice.tax1_label = nil
    invoice.tax2 = 10
    invoice.tax2_label = nil
    invoice.compound = true
    assert invoice.any_taxes?
  end
  
  test 'should has any taxes if tax1 and tax2 present' do
    invoice = users(:one).invoices.new
    invoice.tax1 = 4
    invoice.tax1_label = nil
    invoice.tax2 = 10
    invoice.tax2_label = nil
    invoice.compound = true
    assert invoice.any_taxes?
  end
  
  test "should require upgrade plan if max limit reached" do
    10.times do |x|
      invoice = users(:one).invoices.new(invoices(:one).attributes.slice(:id, :created_at, :updated_at, :slug).merge(subject: "Invoice #{x}", currency: 'USD', customer_id: customers(:one).id, due_date: Time.now, issued_date: Time.now, status: "ABC"))
      invoice.save
    end
    
    invoice = users(:one).invoices.new(subject: "abacsfas", currency: 'USD', customer_id: customers(:one).id, due_date: Time.now, issued_date: Time.now, status: "ABC")
    assert !invoice.save
    assert_equal ["You have reached max 10 invoices limit. Please upgrade plan."], invoice.errors[:base]
  end
  
end
