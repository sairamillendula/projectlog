class AdminMailer < ActionMailer::Base
  default from: "no-reply@getprojectlog.com"
  
  def new_user_registered(new_user)
    @user = new_user
    mail(:to => "app@getprojectlog.com", :subject => "[Projectlog] New user joined")
  end
end
