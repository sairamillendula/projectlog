class AdminMailer < ActionMailer::Base
  default from: "Projectlog <notifications@projectlogapp.com>"
  
  def new_user_registered(user)
    @user = user
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] New user joined")
  end
  
  def new_system_administrator(user)
    @user = user
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] Administrator change")
  end
  
  def new_subscription_email(subscription)
    @subscription = subscription
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] New Subscription")
  end
  
  def cancel_subscription_email(subscription)
    @subscription = subscription
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] Cancelled Subscription")
  end
  
  def new_transaction_created(transaction)
    @transaction = transaction
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] New transaction created")
  end
  
  def ipn_processing_failed(txn_type, txn_id, exception)
    @txn_type = txn_type
    @txn_id = txn_id
    @exception = exception
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] IPN Processing failed")
  end
  
  def credit_card_declined_email(subscription)
    @subscription = subscription
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] User credit card declined")
  end
  
end
