require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have the free plan automatically asigned after creation" do
    u = User.create!(:email => "asdf@adsf.com", :password => "123456")
    assert u.plan, "user doesn't have a plan"
    assert_equal u.plan, Plan.find_by_name!("Free")
    assert User.with_free_plan.all.include?(u)
  end
end
