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
    @subscription = subscription
    mail(:to => @subscription.user.email, :subject => "Your credit card was declined")
  end
  
  def trial_going_to_expire_email(user)
    @user = user
    mail(:to => user.email, :subject => "You have #{Settings['subscriptions.alert_trial_expire']} days left on your trial")
  end
  
  def trial_expired_email(user)
    @user = user
    mail(:to => user.email, :subject => "You trial expired")
  end
end
