require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  test "should create project" do
    project = users(:one).projects.new
    project.customer_id = '1'
    project.title = 'MacBook Air redesign'
    assert_not_nil(project.user_id)
    assert project.save
  end
  
  test "should not save without a title" do
    project = Project.new
    assert !project.valid?
    assert project.errors[:title].any?
    assert_equal ["can't be blank"], project.errors[:title]
    assert !project.save
  end
 
  test "ensure customer_id is present if billable" do
    project = users(:one).projects.new
    project.title = "Project Test"
    project.internal = false
    assert !project.valid?
    assert = project.errors[:customer_id].any?
    assert_equal ["can't be blank"], project.errors[:customer_id]
    project.customer_id = '1'
    assert_not_nil(project.customer_id) 
    assert project.save
  end
  
  test "ensure no customer saved if internal" do
    project = users(:one).projects.new
    project.title = "Project Test"
    project.internal = true
    assert project.valid?
    assert_nil(project.customer_id) 
    assert project.save
  end
  
  test "should find project" do
    project_id = projects(:open_and_internal).id
    assert_nothing_raised { Project.find(project_id) }
  end

  test "should update project" do
    project = projects(:open_and_billable)
    assert project.update_attributes(:title => 'Corporate website redesign')
  end

  test "should destroy project and activities" do
    project = projects(:closed_and_billable)
    project.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Project.find(project.id) }
    assert !project.activities.any?
  end
  
end
