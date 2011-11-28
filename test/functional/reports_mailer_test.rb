require 'test_helper'

class ReportsMailerTest < ActionMailer::TestCase
  test "report_shared_with_you" do
    report = Report.find_by_slug!("thisisthereportslug").id
    remail = Reports::Email.new
    remail.from = "notifications@projectlogapp.com"
    remail.to = "user@gmail.com"
    remail.reply_to = "user@gmail.com"
    remail.subject = "Sharing a report"
    remail.body = "Shared Timesheet: %{report_link}"
    remail.report_link = "grtgrtgtrgtr"

    email = ReportsMailer.report_shared_with_you(remail).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ["user@gmail.com"], email.to
    assert_equal "Sharing a report", email.subject
    assert_equal ["user@gmail.com"], email.reply_to
    assert email.body =~ /Shared Timesheet: grtgrtgtrgtr/
  end
end
