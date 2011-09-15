require 'test_helper'

class ReportsMailerTest < ActionMailer::TestCase
  test "report_shared_with_you" do
    report = Report.find_by_slug!("thisisthereportslug").id
    email = Reports::Email.new
    email.from = "notification@getprojectlog.com"
    email.to = "user@gmail.com"
    email.reply_to = "user@getprojectlog.com"
    email.subject = "Sharing a report"
    email.body = "Shared Timesheet: %{report_link}"
    email.report_link = "grtgrtgtrgtr"

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      email.deliver
    end

    sent = ActionMailer::Base.deliveries.first
    assert_equal ["user@gmail.com"], sent.to
    assert_equal "Sharing a report", sent.subject
    assert_equal ["user@getprojectlog.com"], sent.reply_to
    assert sent.body =~ /Shared Timesheet: grtgrtgtrgtr/
  end
end
