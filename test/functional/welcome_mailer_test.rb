require 'test_helper'

class WelcomeMailerTest < ActionMailer::TestCase
  
  test "should send welcome email to new user" do
      user = User.new
      user.email = 'test@email.com'
      user.password = '123456'
      user.first_name = 'Jean'
      user.last_name = 'Pierre'
      assert user.save
      
      message = WelcomeMailer.welcome_email(user).deliver
      assert_equal "Welcome to Projectlog", message.subject
      assert_equal ["test@email.com"], message.to
  end
  
end