require 'test_helper'
include Devise::TestHelpers

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @activity = activities(:one)
    @project = @activity.project
  end

  test "should get index" do
    get :index, :project_id => @project.to_param
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new, :project_id => @project.to_param
    assert_response :success
    assert_template 'new'
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, :activity => @activity.attributes, :project_id => @project.to_param
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show activity" do
    get :show, :id => @activity.to_param, :project_id => @project.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @activity.to_param, :project_id => @project.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update activity" do
    put :update, :id => @activity.to_param, :activity => @activity.attributes, :project_id => @project.to_param
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, :id => @activity.to_param, :project_id => @project.to_param
    end

    assert_redirected_to project_path(assigns(:project))
  end
end
