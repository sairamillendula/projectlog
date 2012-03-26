class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  # skip_before_filter :verify_authenticity_token
  
  def ipn
    transaction_types = [""]
    puts "Received IPN"
    notify = Paypal::Notification.new(request.raw_post)
    if notify.acknowledge
      begin
        txn_type = notify.type
        
        # call appropriate handle base on transaction type
        send(txn_type, notify)
        
      rescue => e
        # email to admin
        raise
      end
    end
    render :nothing => true
  end
  
  private
  
  # HANDLE IPN 
  # https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_WPRecurringPayments
  # https://cms.paypal.com/cms_content/US/en_US/files/developer/IPNGuide.pdf
  # https://www.x.com/developers/community/blogs/ppmacole/recurring-payments-ipns (new)
  # ----------
  
  # user has been billed
  def recurring_payment(notify)
    subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
    subscription.next_payment_date = Time.zone.parse(notify.params['next_payment_date'])
    subscription.save
    
    SubscriptionTransaction.create(code: notify.transaction_id, 
                                   amount: subscription.plan.price, 
                                   subscription_id: subscription.id, 
                                   user_id: subscription.user_id)
  end
  
  def recurring_payment_failed(notify)
    
  end
  
  def recurring_payment_expired(notify)
    # not applicable since we dont limited number of subscription
  end
  
  # profile suspended due to max payment failed, number of failed is configured in 
  # see initializers/settings.rb
  # see Subscription#profile_options
  def recurring_payment_suspended_due_to_max_failed_payment(notify)
    
  end
  
  # profile created, not billed yet
  def recurring_payment_profile_created(notify)
    subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
    subscription.next_payment_date = Time.zone.parse(notify.params['next_payment_date'])
    subscription.save
  end
  
  def recurring_payment_profile_cancel(notify)
    
  end
  
  def recurring_payment_outstanding_payment(notify)
    # TODO: send email to admin
  end
  
  def recurring_payment_outstanding_payment_failed(notify)
    # TODO: send email to admin
  end

  def recurring_payment_skipped(notify)
    # kind of payment failed
  end
  
end