class SubscriptionsMailer < ActionMailer::Base
  default from: "Projectlog <notifications@projectlogapp.com>"
  
  def new_subscription_email(subscription)
    @subscription = subscription
    mail(:to => @subscription.user.email, :subject => "Thanks for subscribing to Projectlog")
  end
  
  def update_subscription_email(subscription)
    @subscription = subscription
    mail(:to => @subscription.user.email, :subject => "Subscription change")
  end
  
  def credit_card_declined_email(subscription)
    
  end
end
