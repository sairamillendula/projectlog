require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  
  test "should send email to Admin for every new signup" do
      user = User.new
      user.email = 'test@email.com'
      user.password = '123456'
      user.first_name = 'Jean'
      user.last_name = 'Pierre'
      assert user.save
      
      message = AdminMailer.new_user_registered(user).deliver
      assert_equal "[Projectlog] New user joined", message.subject
      assert_equal ["app@projectlogapp.com"], message.to
      assert message.body =~ /test@email.com/
  end
  
  test "should send email to Admin when :admin attribute changes" do
      # First new admin joins
      user = users(:one)
      user.admin = true
      assert user.save
      
      message = AdminMailer.new_system_administrator(user).deliver
      assert_equal "[Projectlog] Administrator change", message.subject
      assert_equal ["app@projectlogapp.com"], message.to
      
      # Repeat if admin becomes standard user again
      user.admin = false
      assert user.save
      
      message = AdminMailer.new_system_administrator(user).deliver
      assert_equal "[Projectlog] Administrator change", message.subject
      assert_equal ["app@projectlogapp.com"], message.to
  end
  
end
