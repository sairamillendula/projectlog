require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  
  test "process modifications" do
    user = users(:paid)
    subscription = subscriptions(:changed)
    subscription.modify_on = Time.now
    subscription.save
    subscription.reload
    
    puts subscription.respond_to?(:deactivate)
    
    pending_subscription = subscription.pending_subscription
    Timecop.travel(Time.now + 1.day) do
      Subscription.process_modifications
      
      assert !subscription.reload.active?
      assert pending_subscription.reload.active?
      
      assert subscription.user.current_subscription == pending_subscription
    end
  end
  
end
