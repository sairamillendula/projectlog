require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  
  test "should create plan" do
    p = Plan.new
    p.name = "This is free"
    p.price = 0
    p.active = true
    assert p.save
  end
  
  test "Mandatory fields must be filled in" do
    p = Plan.new
    assert !p.valid?
    assert = p.errors[:name].any?
    assert = p.errors[:price].any?
    assert = p.errors[:active].any?
    assert_equal ["can't be blank"], p.errors[:name]
    assert_equal ["can't be blank"], p.errors[:price] 
    assert_equal ["can't be blank"], p.errors[:active]
    assert !p.save
  end
  
  test "Name should be unique" do
    p = Plan.create(:name => 'Free', :price => '0', :active => true )
    assert !p.valid?
    assert = p.errors[:name].any?
    assert_equal ["has already been taken"], p.errors[:name]
    assert !p.save
  end
  
  test "should find plan" do
    plan_id = plans(:free).id
    assert_nothing_raised { Plan.find(plan_id) }
  end
  
  test "should update plan" do
    p = plans(:free)
    assert p.update_attributes(:description => 'This is the Free plan')
  end
  
  test "should be able to destroy plan if not attached to some users" do
    p = plans(:free)
    p.users = []
    p.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Plan.find(p.id) }
  end
  
  test "should not be able to destroy plan if still attached to some users" do
    p = plans(:free)
    u = users(:one)
    u.plan = p
    u.save!
    assert p.users.count > 0, "plan doesn't have users"
    assert_raise(ActiveRecord::DeleteRestrictionError) { p.destroy }
  end
  
end
