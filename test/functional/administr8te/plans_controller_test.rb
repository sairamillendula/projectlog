require 'test_helper'

class Administr8te::PlansControllerTest < ActionController::TestCase
  setup do
    @administr8te_plan = administr8te_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:administr8te_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create administr8te_plan" do
    assert_difference('Administr8te::Plan.count') do
      post :create, administr8te_plan: @administr8te_plan.attributes
    end

    assert_redirected_to administr8te_plan_path(assigns(:administr8te_plan))
  end

  test "should show administr8te_plan" do
    get :show, id: @administr8te_plan.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @administr8te_plan.to_param
    assert_response :success
  end

  test "should update administr8te_plan" do
    put :update, id: @administr8te_plan.to_param, administr8te_plan: @administr8te_plan.attributes
    assert_redirected_to administr8te_plan_path(assigns(:administr8te_plan))
  end

  test "should destroy administr8te_plan" do
    assert_difference('Administr8te::Plan.count', -1) do
      delete :destroy, id: @administr8te_plan.to_param
    end

    assert_redirected_to administr8te_plans_path
  end
end
