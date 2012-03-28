require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase

  test "should show new subscription page" do
    sign_in users(:no_plan)
    get :new
    assert_response :success
    assert_not_nil assigns(:subscription)
  end
  
  test "should create new subscription" do
    sign_in users(:no_plan)
    post :create, :subscription => {:card_name => 'Foo Bar', :card_number => "1", :card_code => "123", :card_expiration => {:month => 3, :year => 2017}}
    assert assigns(:subscription).active?
    assert_redirected_to success_subscription_url(assigns(:subscription))
    # check email sent
  end
  
  test "should show edit subscription page" do
    sign_in users(:three)
    get :edit
    assert_response :success
    assert_not_nil assigns(:subscription)
  end
  
  test "should update subscription" do
    sign_in users(:three)
    put :update, :subscription => {:card_name => 'Foo Bar', :card_number => "1", :card_code => "123", :card_expiration => {:month => 3, :year => 2017}}
    assert_redirected_to success_subscription_url(assigns(:subscription))
  end
  
  test "should cancel subscription" do
    user = users(:three)
    sign_in user
    Subscription.gateway.create_dummy_profile(user.current_subscription.attributes.merge(:profile_id => user.current_subscription.paypal_profile_id))
    
    delete :cancel
    assert_redirected_to current_subscriptions_url
  end
  
  test "should show reactivate subscription page" do
    user = users(:three)
    user.current_subscription.update_attribute(:next_payment_date, Time.now)
    user.current_subscription.reload
    sign_in users(:three)
    
    get :modify
    assert_response :success
    assert_not_nil assigns(:subscription)
  end
  
  test "should reactivate subscription" do
    sign_in users(:three)
    
    put :reactivate, :subscription => {:card_name => 'Foo Bar', :card_number => "1", :card_code => "123", :card_expiration => {:month => 3, :year => 2017}}
    assert_redirected_to current_subscriptions_url
  end
end
