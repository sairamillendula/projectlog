require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  
  test "should create announcement" do
    a = Announcement.new
    a.message = "Maintenance next week"
    a.starts_at = "2011-06-23"
    a.ends_at = "2011-06-26"
    assert a.save
  end
  
  test "Mandatory fields must be filled in" do
    a = Announcement.new
    assert !a.valid?
    assert = a.errors[:message].any?
    assert = a.errors[:starts_at].any?
    assert = a.errors[:ends_at].any?
    assert_equal ["can't be blank"], a.errors[:message]
    assert_equal ["can't be blank"], a.errors[:starts_at] 
    assert_equal ["can't be blank"], a.errors[:ends_at]
    assert !a.save
  end
  
  test "end date must be greater than start date" do
    a = announcements(:one)
    a.update_attributes(:ends_at => '2010-10-10')
    assert !a.valid?
    assert a.errors[:starts_at].any?
    assert_equal ["must be smaller than end date"], a.errors[:starts_at]
    assert !a.save
  end
  
  test "should find announcement" do
    announcement_id = announcements(:one).id
    assert_nothing_raised { Announcement.find(announcement_id) }
  end
  
  test "should update announcement" do
    a = announcements(:one)
    assert a.update_attributes(:message => 'New Blog Post')
  end
  
  test "should be able to destroy announcement" do
    a = announcements(:two)
    a.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Announcement.find(a.id) }
  end
  
  test "ensure user can acknowledge announcement" do
    user = users(:one)
    a = announcements(:one)
    a.hide_for!(user)
    assert a.hidden_by?(user)
  end
  
  test "#current_announcement for some user" do
    a = announcements(:two)
    a.hidden_by_user_ids = []
    a.starts_at = Time.now - 5.days
    a.ends_at = Time.now + 5.days

    assert_equal a, Announcement.current_announcement_for(users(:one))
  end
  
end
