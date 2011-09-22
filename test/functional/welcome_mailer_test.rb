require 'test_helper'

class WelcomeMailerTest < ActionMailer::TestCase
  
  test "should send welcome email to new user" do
      user = users(:one)
      assert user.save
      
      message = WelcomeMailer.welcome_email(user).deliver
      assert_equal "Welcome to Projectlog", message.subject
      assert_equal ["user@gmail.com"], message.to
      assert message.body =~ /projectlogapp.com/
      assert message.body =~ /login/
  end
  
end