class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  # skip_before_filter :verify_authenticity_token
  
  class SubscriptionError < Exception;end
  
  def ipn
    puts "Received IPN"
    notify = Paypal::Notification.new(request.raw_post)
    if notify.acknowledge
      begin
        txn_type = notify.type
        # call appropriate handle base on transaction type
        send(txn_type, notify)
         
      rescue SubscriptionError => e
        AdminMailer.ipn_processing_failed(notify.type, notify.transaction_id, e).deliver
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
    begin
      Subscription.transaction do
	      subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
	      subscription.next_payment_date = Time.strptime(params['next_payment_date'], "%H:%M:%S %b %d, %Y %Z").in_time_zone
	      subscription.save(validate: false)
	    
	      transaction = SubscriptionTransaction.new(code: notify.transaction_id, 
	                                     amount: subscription.plan.price, 
	                                     subscription_id: subscription.id, 
	                                     user_id: subscription.user_id)
	      if transaction.save                               
	        begin
	          SubscriptionTransactionsMailer.payment_receipt_email(transaction).deliver
	        rescue
	          
	        end
	      else
	        raise SubscriptionError
	      end
	    end
    rescue
      raise SubscriptionError
    end
    
  end
  
  def recurring_payment_failed(notify)
    # NOT APPLICABLE, PAYPAL SEND RECURRING_PAYMENT_SUSPENDED_DUE_TO_MAX_FAILED_PAYMENT INSTEAD
  end
  
  def recurring_payment_expired(notify)
    # NOT APPLICABLE SINCE WE DONT LIMIT NUMBER OF SUBSCRIPTION
  end
  
  # profile suspended due to max payment failed, number of failed attempts is configured in 
  # see initializers/settings.rb
  # see Subscription#profile_options
  def recurring_payment_suspended_due_to_max_failed_payment(notify)
    puts "recurring_payment_suspended_due_to_max_failed_payment"
    begin
      subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
      subscription.cancel(:timeframe => :renewal)
      puts "cancelled"
    rescue
      raise SubscriptionError
    end
  end
  
  # profile created, not billed yet
  def recurring_payment_profile_created(notify)
    begin
      subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
	    subscription.next_payment_date = Time.strptime(params['next_payment_date'], "%H:%M:%S %b %d, %Y %Z").in_time_zone
	    subscription.save(validate: false)
    rescue
      raise SubscriptionError
    end
    
  end
  
  def recurring_payment_profile_cancel(notify)
    subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
    
    # make sure subscription is cancelled
    unless subscription.cancelled?
      subscription.cancel(:timeframe => :renewal)
    end
  end
  
  def recurring_payment_outstanding_payment(notify)
    # NOT APPLICABLE, WE DON'T INCLUDE EXTRA AMOUNT
  end
  
  def recurring_payment_outstanding_payment_failed(notify)
    # NOT APPLICABLE, WE DON'T INCLUDE EXTRA AMOUNT
  end

  def recurring_payment_skipped(notify)
    # NOT APPLICABLE
    # some error occured at paypal side, it will send us recurring_payment_suspended_due_to_max_failed_payment ipn
    # so we leave the job for recurring_payment_suspended_due_to_max_failed_payment
  end
  
end