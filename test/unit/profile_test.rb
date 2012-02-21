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
  
  test "fiscal period" do
    p = Profile.new
    this_year = 2012
    p.fiscal_year = Date.new(2000, 6, 15)
    
    assert_equal (Date.new(2011, 6, 15)..Date.new(2012, 6, 15)), p.fiscal_period(this_year)
  end
  
  test "default fiscal period" do
    p = Profile.new
    this_year = 2012
    assert_equal (Date.new(2011, 1, 1)..Date.new(2012, 1, 1)), p.fiscal_period(this_year)
  end
end
