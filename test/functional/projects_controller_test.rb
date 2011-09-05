require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @project = projects(:open_and_billable)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:open_projects)
    assert_not_nil assigns(:closed_projects)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => @project.attributes.merge(:title => "#{@project.title} 2")
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, :id => @project.to_param
    assert_response :success
    assert_template 'show'
  end

  test "should get edit" do
    get :edit, :id => @project.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update project" do
    put :update, :id => @project.to_param, :project => @project.attributes
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => @project.to_param
    end

    assert_redirected_to projects_path
  end
end
