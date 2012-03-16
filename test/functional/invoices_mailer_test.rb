require 'test_helper'

class InvoicesMailerTest < ActionMailer::TestCase
  
  test "should send invoice to client without attach" do
      user = users(:one)
      assert user.save
      
      invoice = invoices(:one)
      assert invoice.save
      
      contact = contacts(:three)
      assert contact.save
      
      message = InvoicesMailer.invoice_by_email(invoice, "Invoice for bla-bla", "See invoice attached", user, contact.email, nil).deliver
      assert_equal "Invoice for bla-bla", message.subject
      assert_equal ["erin.kelly@zylog.com"], message.to
      assert message.body =~ /See invoice attached/
  end
  
end