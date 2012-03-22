class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  # skip_before_filter :verify_authenticity_token
  
  def ipn
    puts "Received IPN"
    notify = Paypal::Notification.new(request.raw_post)
    if notify.acknowledge
      begin
        if notify.complete?
          # TODO: send email
          subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
          SubscriptionTransaction.create(code: notify.transaction_id, 
                                         amount: subscription.plan.price, 
                                         subscription_id: subscription.id, 
                                         user_id: subscription.user_id)
        end
      rescue => e
        raise
      end
    end
    render :nothing => true
  end
end