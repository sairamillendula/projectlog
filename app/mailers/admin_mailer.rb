class AdminMailer < ActionMailer::Base
  default from: "no-reply@getprojectlog.com"
  
  def new_user_registered(new_user)
    @user = new_user
    mail(:to => "olivier.simart@gmail.com", :subject => "[Projectlog] New user registered")
  end
end
