require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  test "should create activity" do
    a = users(:one).activities.new
    a.project_id = '1'
    a.date = '2011-09-26'
    a.time = '2'
    a.description = 'MacBook Air features redesign'
    assert_not_nil(a.project_id)
    assert a.save
  end
  
  test "make sure mandatory fields are filled in" do
    activity = Activity.new
    assert !activity.valid?
    assert activity.errors[:date].any?
    assert activity.errors[:time].any?
    assert activity.errors[:description].any?
    assert activity.errors[:project_id].any?
    assert_equal ["can't be blank"], activity.errors[:date]
    assert_equal ["is not a number", "can't be blank"], activity.errors[:time]
    assert_equal ["can't be blank"], activity.errors[:description]
    assert_equal ["can't be blank"], activity.errors[:project_id]
    assert !activity.save
  end
  
  test "should find activity" do
    activity_id = activities(:one).id
    assert_nothing_raised { Activity.find(activity_id) }
  end

  test "should update activity" do
    assert activities(:one).update_attributes(:description => 'Corporate website redesign')
  end

  test "should destroy activity" do
    activity = activities(:one)
    activity.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Activity.find(activity.id) }
  end
  
end
