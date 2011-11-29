require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should create category" do
    category = users(:one).categories.new
    category.name = 'Category1'
    assert_not_nil(category.user_id)
    assert category.save
  end
  
  test "should not save without a name" do
    category = Category.new
    assert !category.valid?
    assert category.errors[:name].any?
    assert_equal ["can't be blank"], category.errors[:name]
    assert !category.save
  end
  
  test "validate uniqueness of name for given user" do
    category = users(:one).categories.new
    category.name = "Cat A"
    assert category.valid?
    assert category.save
    category = users(:one).categories.new
    category.name = "Cat A"
    assert !category.valid?
    assert !category.save
    category = users(:two).categories.new
    category.name = "Cat A"
    assert category.valid?
    assert category.save
  end
  
  test "should find category" do
    category_id = categories(:one).id
    assert_nothing_raised { Category.find(category_id) }
  end

  test "should update category" do
    category = categories(:one)
    assert category.update_attributes(:name => 'Web')
  end

  test "should destroy category" do
    category = categories(:one)
    category.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Category.find(category.id) }
  end
end