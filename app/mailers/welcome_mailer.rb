class WelcomeMailer < ActionMailer::Base
  default from: "Projectlog <contact@getprojectlog.com>"
  
  def welcome_email(new_user)
    @user = new_user
    mail(:to => @user.email, :subject => "Welcome to Projectlog")
  end
  
end