class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  # skip_before_filter :verify_authenticity_token
  
  def ipn
    puts "Received IPN"
    notify = Paypal::Notification.new(request.raw_post)
    if notify.acknowledge
      begin
        txn_type = notify.type
        # call appropriate handle base on transaction type
        send(txn_type, notify)
         
      rescue => e
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
	      subscription.save!(validate: false)
	    
	      transaction = SubscriptionTransaction.new(code: notify.transaction_id, 
	                                     amount: subscription.plan.price, 
	                                     subscription_id: subscription.id, 
	                                     user_id: subscription.user_id)
	      if transaction.save                               
	        begin
	          SubscriptionTransactionsMailer.payment_receipt_email(transaction).deliver
	        rescue => e
	          puts "Failed to send email due to #{e}"
	        end
        else
          raise "cannot create transaction."
	      end
	    end
    rescue => e
      raise "Failed to process recurring_payment IPN due to #{e}"
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
    begin
      subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
      if subscription.cancel(:timeframe => :renewal)
        subscription.card_declined = true
        subscription.save(validate: false)
        AdminMailer.credit_card_declined_email(subscription)
        SubscriptionsMailer.credit_card_declined_email(subscription)
      else
        raise "Failed to cancel subscription" 
      end
    rescue => e
      puts e
      raise "Failed to process recurring_payment_suspended_due_to_max_failed_payment IPN."
    end
  end
  
  # profile created, not billed yet, CAN BE FAILED SILENCELY!
  def recurring_payment_profile_created(notify)
    subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
    subscription.next_payment_date = Time.strptime(params['next_payment_date'], "%H:%M:%S %b %d, %Y %Z").in_time_zone
    subscription.save(validate: false)
  end
  
  def recurring_payment_profile_cancel(notify)
    begin
      subscription = Subscription.find_by_slug(notify.params['rp_invoice_id'])
    
      # make sure subscription is cancelled
      unless subscription.cancelled?
        raise unless subscription.cancel(:timeframe => :renewal)
      end
    rescue => e
      puts e
      raise "Failed to process recurring_payment_profile_cancel IPN"
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
    # if some error occured on paypal side, it will send us recurring_payment_suspended_due_to_max_failed_payment ipn
    # so we leave the job for recurring_payment_suspended_due_to_max_failed_payment
  end
  
end