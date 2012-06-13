require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  
  test "should create report" do
    report = Report.new
    report.user_id = users(:one)
    report.start_date = '2011-04-26'
    report.end_date = '2012-04-26'
    assert_not_nil(report.user_id)
    assert report.save
    assert_not_nil report.slug
  end
  
  test "mandatory fields should be filled in" do
    report = Report.new
    assert !report.valid?
    assert report.errors[:user_id].any?
    assert_equal ["can't be blank"], report.errors[:user_id]
    assert !report.save
  end
  
  test "end date must be greater than start date" do
    report = Report.new
    report.user_id = users(:one)
    report.start_date = '2011-04-26'
    report.end_date = '2010-04-26'
    assert !report.valid?
    assert report.errors[:start_date].any?
    assert_equal ["must be smaller than end date"], report.errors[:start_date]
    assert !report.save
  end
  
end
