require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "should create profile" do
    p = Profile.new
    p.user_id = users(:one)
    assert p.save
  end
  
  test "should update profile" do
    p = profiles(:one)
    assert p.update_attributes(:company => 'Zorro', :localization => '3')
  end
  
  test "should destroy profile" do
    p = users(:one).profile
    u = users(:one).destroy
    assert_raise(ActiveRecord::RecordNotFound) { Profile.find(p.id) }
  end
  
end
