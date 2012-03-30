require 'test_helper'

class PaypalControllerTest < ActionController::TestCase
  require 'paypal_ipn_mock'
  
  setup do
    @user = users(:three)
    @subscription = @user.current_subscription
    @transaction_id = "16F08736TA389152H"
    @next_payment_date = (Time.zone.now + 1.month)
    @ipn_params = {
      "next_payment_date" => @next_payment_date.strftime("%H:%M:%S %b %d, %Y %Z"),
      "txn_type" => "web_accept",
      "last_name" => "User",
      "residence_country" => "US",
      "item_name" => "FWJ - 3 Credits",
      "payment_gross" => "180.00",
      "mc_currency" => "USD",
      "business" => "projectlog",
      "payment_type" => "instant",
      "verify_sign" => "AZQLcOZ7B.YM2m-QDAXOrQQcLFYuA0N0XoC3zadaGhkGNF2nlRWmpzlI",
      "payer_status" => "verified",
      "test_ipn" => "1",
      "tax" => "0.00",
      "payer_email" => "foo@bar.com" ,
      "txn_id" => @transaction_id,
      "quantity" => "1",
      "receiver_email" => "projectlog@foo.com",
      "first_name" => "Test",
      "payer_id" =>  "293482394",
      "receiver_id" => "209340239402",
      "item_number" => "3",
      "payment_status" => "Completed",
      "payment_fee" => "5.52",
      "mc_fee" => "5.52",
      "shipping" => "0.00",
      "mc_gross" => "180.00",
      "custom" => "3",
      "charset" => "windows-1252",
      "notify_version" => "2.4"
    }
    Subscription.gateway.create_dummy_profile(@subscription.attributes.merge(:profile_id => @subscription.paypal_profile_id))
    
    # WARNING: any stubs in test cases should be unstub here!
    SubscriptionTransaction.any_instance.unstub(:save)
    
    Subscription.any_instance.unstub(:cancel)
    Subscription.any_instance.unstub(:cancelled)
  end
  
  test "recurring_payment success" do
    post :ipn, @ipn_params.merge("txn_type" => "recurring_payment", "rp_invoice_id" => @subscription.slug)
    assert_response :success
    
    @subscription.reload
    
    assert_not_nil @subscription.next_payment_date
    assert_not_nil @subscription.subscription_transactions
    assert_not_equal [], @subscription.subscription_transactions
    
    # send receipt email to user
    assert_equal @subscription.user.email, ActionMailer::Base.deliveries.last.to.first
  end
  
  test "recurring_payment fail" do
    SubscriptionTransaction.any_instance.stubs(:save).returns(false)
    assert_raise RuntimeError do
      post :ipn, @ipn_params.merge("txn_type" => "recurring_payment", "rp_invoice_id" => @subscription.slug)
    end
    
    # send error email to admin
    assert_equal "app@projectlogapp.com", ActionMailer::Base.deliveries.last.to.first
  end
  
  test "recurring_payment_suspended_due_to_max_failed_payment success" do
    AdminMailer.expects(:credit_card_declined_email).once
    SubscriptionsMailer.expects(:credit_card_declined_email).once
    
    post :ipn, @ipn_params.merge("txn_type" => "recurring_payment_suspended_due_to_max_failed_payment", "rp_invoice_id" => @subscription.slug)
    assert_response :success
    
    @subscription.reload
    
    assert @subscription.cancelled?
    assert_equal @next_payment_date.to_date, @subscription.modify_on.to_date
    assert_nil @subscription.pending_subscription
    
    # send declined email to user
    
    # assert_equal @subscription.user.email, ActionMailer::Base.deliveries.last.to.first
  end
  
  test "recurring_payment_suspended_due_to_max_failed_payment fail" do
    Subscription.any_instance.stubs(:cancel).returns(false)
    assert_raise RuntimeError do
      post :ipn, @ipn_params.merge("txn_type" => "recurring_payment_suspended_due_to_max_failed_payment", "rp_invoice_id" => @subscription.slug)
    end
    # send error email to admin
    assert_equal "app@projectlogapp.com", ActionMailer::Base.deliveries.last.to.first
  end
  
  test "recurring_payment_profile_created" do
    pass
  end
  
  test "recurring_payment_profile_cancel success" do
    Subscription.any_instance.stubs(:cancelled).returns(false)
    post :ipn, @ipn_params.merge("txn_type" => "recurring_payment_profile_cancel", "rp_invoice_id" => @subscription.slug)
    assert_response :success
    
    @subscription.reload
    
    assert @subscription.cancelled?
    assert_equal @next_payment_date.to_date, @subscription.modify_on.to_date
  end
  
  test "recurring_payment_profile_cancel fail" do
    Subscription.any_instance.stubs(:cancelled).returns(false)
    Subscription.any_instance.stubs(:cancel).returns(false)
    
    assert_raise RuntimeError do
      post :ipn, @ipn_params.merge("txn_type" => "recurring_payment_profile_cancel", "rp_invoice_id" => @subscription.slug)
    end
    # send error email to admin
    assert_equal "app@projectlogapp.com", ActionMailer::Base.deliveries.last.to.first
  end
  
end