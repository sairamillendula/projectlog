require 'test_helper'

class Administr8te::PlansControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @plan = plans(:paid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create administr8te_plan" do
    assert_difference('Plan.count') do
      post :create, plan: @plan.attributes.merge(name: "#{@plan.name} 2")
    end

    assert_redirected_to administr8te_plan_path(assigns(:plan))
  end

  test "should show administr8te_plan" do
    get :show, id: @plan.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plan.to_param
    assert_response :success
  end

  test "should update administr8te_plan" do
    put :update, id: @plan.to_param, plan: @plan.attributes
    assert_redirected_to administr8te_plan_path(assigns(:plan))
  end

  test "should destroy administr8te_plan" do
    @plan.users = [] # You can only destroy a plan if it doesn't have users
    @plan.save!
    assert_difference('Plan.count', -1) do
      delete :destroy, id: @plan.to_param
    end

    assert_redirected_to administr8te_plans_path
  end
end
