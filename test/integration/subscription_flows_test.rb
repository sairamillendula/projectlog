require 'test_helper'
include Devise::TestHelpers

class SubscriptionFlowsTest < ActionDispatch::IntegrationTest
  require 'paypal_ipn_mock'
  fixtures :all
  
  def setup
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
    Timecop.return
  end
  
  test "login, subscribe a plan, cancel and reactivate" do
    https!
    get login_path
    assert_response :success

    post_via_redirect new_user_session_path, user: {email: users(:one).email, password: "123456", remember_me: "0"}
    assert_response :success
    
    # visit subscription page
    get new_subscription_path
    assert_response :success
    assert_template 'new'
    
    # subscribe
    post_via_redirect subscriptions_path, :subscription => {:card_name => 'Foo Bar', :card_number => "1", :card_code => "123", :card_expiration => {:month => 3, :year => 2017}}
    # assert_equal 2, ActionMailer::Base.deliveries.size
    assert ActionMailer::Base.deliveries.map{|mail| mail.to.first}.include?("app@projectlogapp.com"), "Send email to admin"
    assert ActionMailer::Base.deliveries.map{|mail| mail.to.first}.include?(users(:one).email), "Send email to user"
    
    assert_response :success
    assert_template :success
    assert_not_nil current_subscription
    
    # view current subscription
    get current_subscriptions_path
    assert_response :success
    assert_template 'current'
    
    # paypal send 'recurring_payment' IPN
    post paypal_ipn_path, @ipn_params.merge("txn_type" => "recurring_payment", "rp_invoice_id" => current_subscription.slug)
    
    assert_not_nil current_user.subscription_transactions
    assert_not_equal [], current_user.subscription_transactions
    assert_equal users(:one).email, ActionMailer::Base.deliveries.last.to.first
    
    # check current subscription has transaction
    get current_subscriptions_path
    assert_response :success
    assert_template 'current'
    assert_match /#{@transaction_id}/, response.body
    assert_match /Next payment will be processed on #{@next_payment_date.strftime('%B %d, %Y')}/, response.body
    assert_match /Edit Subscription/, response.body
    
    # cancel 
    delete cancel_subscriptions_path
    assert_redirected_to current_subscriptions_path
    follow_redirect!
    assert_match /Your subscription has been cancelled successfully/, response.body
    assert current_subscription.cancelled?
    
    # visit reactivate
    get modify_subscriptions_path
    assert_response :success
    assert_template 'new'
    
    # reactivate
    put reactivate_subscriptions_path, :subscription => {:card_name => 'Foo Bar', :card_number => "1", :card_code => "123", :card_expiration => {:month => 3, :year => 2017}}
    assert_redirected_to current_subscriptions_path
    follow_redirect!
    assert_match /Your subscription has been reactivated successfully/, response.body
    assert current_subscription.active?
    assert_not_nil current_subscription.pending_subscription
  end
  
  def current_user
    controller.current_user
  end
  
  def current_subscription
    current_user.current_subscription
  end
  
end
