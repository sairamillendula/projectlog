class AdminMailer < ActionMailer::Base
  default from: "no-reply@getprojectlog.com"
  
  def new_user_registered(new_user)
    @user = new_user
    mail(:to => "app@getprojectlog.com", :subject => "[Projectlog] New user joined")
  end
  
  def new_system_administrator(user)
    @user = user
    mail(:to => "app@getprojectlog.com", :subject => "[Projectlog] Administrator change")
  end
  
end
