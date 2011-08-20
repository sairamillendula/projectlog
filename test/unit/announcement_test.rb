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
    user_id = users(:one).id
    announcements(:one).hidden_by_user_ids = user_id
    assert_not_nil announcements(:one).hidden_by_user_ids
  end
  
  test "ensure current announcements work" do
    #announcements(:two) should be active based on fixture
    assert Announcement.current_announcements.any?
  end
  
end
