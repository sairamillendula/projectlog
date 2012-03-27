class SubscriptionTransactionsMailer < ActionMailer::Base
  default from: "Projectlog <notifications@projectlogapp.com>"
  
  def payment_receipt_email(subscription_transaction)
    @transaction = subscription_transaction
    mail(:to => @transaction.user.email, :subject => "Projectlog Payment Receipt")
  end
  
  def subscription_cancelled_email(subscription)
    @subscription = subscription
    mail(:to => @subscription.user.email, :subject => "Projectlog Subscription Cancelled")
  end
end
