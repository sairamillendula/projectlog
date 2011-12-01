class AdminMailer < ActionMailer::Base
  default from: "notifications@projectlogapp.com"
  
  def new_user_registered(user)
    @user = user
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] New user joined")
  end
  
  def new_system_administrator(user)
    @user = user
    mail(:to => "app@projectlogapp.com", :subject => "[Projectlog] Administrator change")
  end
  
end
