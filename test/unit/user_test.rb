require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "should create user" do
    u = User.new
    u.email = 'test@email.com'
    u.password = '123456'
    u.first_name = 'Jean'
    u.last_name = 'Pierre'
    assert u.save
  end
  
  test "profile should be created automatically" do
    profile_id = users(:one).id
    assert_nothing_raised { Profile.find(profile_id) }
  end
  
  test "Mandatory fields must be filled in" do
    u = User.new
    assert !u.valid?
    assert = u.errors[:email].any?
    assert = u.errors[:password].any?
    assert = u.errors[:first_name].any?
    assert = u.errors[:last_name].any?
    assert_equal ["can't be blank"], u.errors[:email]
    assert_equal ["can't be blank"], u.errors[:password] 
    assert_equal ["can't be blank"], u.errors[:first_name]
    assert_equal ["can't be blank"], u.errors[:last_name]
    assert !u.save
  end
  
  test "Email should be unique" do
    # Same Email than user one in fixture
    u2 = User.create(:email => 'user@gmail.com', :password => '123456', :first_name => 'O', :last_name => 'Li' )
    assert !u2.valid?
    assert = u2.errors[:email].any?
    assert_equal ["has already been taken"], u2.errors[:email]
    assert !u2.save
  end
  
  test "should have the free plan automatically asigned after creation" do
    u = User.create!(:email => "asdf@adsf.com", :password => "123456", :first_name => 'A', :last_name => 'M')
    assert u.plan, "user doesn't have a plan"
    assert_equal u.plan, Plan.find_by_name!("Free")
    assert User.with_free_plan.all.include?(u)
  end
  
  test "should find user" do
    user_id = users(:one).id
    assert_nothing_raised { User.find(user_id) }
  end
  
  test "should update user" do
    u = users(:one)
    assert u.update_attributes(:first_name => 'Arthur')
    assert_not_nil u.email
    assert_not_nil u.encrypted_password
    assert_not_nil u.first_name
    assert_not_nil u.last_name
  end
  
  test "should be able to upgrade/downgrade plan" do
    u = users(:one)
    assert u.update_attributes(:plan_id => 2)
    assert u.update_attributes(:plan_id => 1)
  end
  
  test "Email should remain unique on update" do
    u = users(:one)
    u.update_attributes(:email => 'user2@gmail.com') # user two Email in fixture
    assert !u.valid?
    assert = u.errors[:email].any?
    assert_equal ["has already been taken"], u.errors[:email]
    assert !u.save
  end
  
  test "should destroy user and remove everything associated" do
    u = users(:one)
    u.destroy
    assert_raise(ActiveRecord::RecordNotFound) { User.find(u.id) }
    assert_nil u.profile
    assert !u.customers.any?
    assert !u.projects.any?
    assert !u.activities.any?
  end
  
end
