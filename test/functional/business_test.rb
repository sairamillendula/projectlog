require 'test_helper'

class BusinessTest < ActionMailer::TestCase
  test "timesheet" do
    mail = Business.timesheet
    assert_equal "Timesheet", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
