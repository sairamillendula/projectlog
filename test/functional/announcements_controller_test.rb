require 'test_helper'
include Devise::TestHelpers

class AnnouncementsControllerTest < ActionController::TestCase
  setup do
    @announcement = announcements(:one)
  end

  test "should redirect to next announcement if there are 2 pending announcements" do
    sign_in users(:one)
    
    @announcement.starts_at = Time.now - 5.days
    @announcement.ends_at = Time.now + 5.days
    @announcement.save!
    
    put :hide, :id => @announcement
    assert_redirected_to announcement_path(announcements(:two))
  end

end
