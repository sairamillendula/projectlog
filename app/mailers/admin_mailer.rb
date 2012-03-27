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
end
