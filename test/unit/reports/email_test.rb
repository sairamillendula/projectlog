require 'test_helper'

class Reports::EmailTest < ActiveSupport::TestCase
  
  test "should send email" do
    report = Report.find_by_slug!("thisisthereportslug").id
    email = Reports::Email.new
    email.from = "notification@getprojectlog.com"
    email.to = "user@gmail.com"
    email.reply_to = "user@getprojectlog.com"
    email.subject = "Sharing a report"
    email.body = "Shared Timesheet"
    email.report_link = "grtgrtgtrgtr"
    assert email.deliver
  end
  
  test "mandatory fields should be filled in" do
    report = reports(:one).id
    email = Reports::Email.new
    assert !email.valid?
    assert email.errors[:to].any?
    assert email.errors[:from].any?
    assert email.errors[:subject].any?
    assert email.errors[:body].any?
    assert email.errors[:report_link].any?
    assert email.errors[:reply_to].any?
    assert email.errors[:slug].any?
    assert_equal ["can't be blank"], email.errors[:to]
    assert_equal ["can't be blank"], email.errors[:from]
    assert_equal ["can't be blank"], email.errors[:subject]
    assert_equal ["can't be blank"], email.errors[:body]
    assert_equal ["can't be blank"], email.errors[:report_link]
    assert_equal ["can't be blank"], email.errors[:reply_to]
    assert_equal ["can't be blank"], email.errors[:slug]
    assert !email.deliver
  end
  
end
