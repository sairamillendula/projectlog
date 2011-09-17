class WelcomeMailer < ActionMailer::Base
  default from: "Projectlog <notifications@projectlogapp.com>"
  
  def welcome_email(new_user)
    @user = new_user
    mail(:to => @user.email, :subject => "Welcome to Projectlog")
  end
  
end