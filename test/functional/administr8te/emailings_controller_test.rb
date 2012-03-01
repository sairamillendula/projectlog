require 'test_helper'

class Administr8te::EmailingsControllerTest < ActionController::TestCase
  test "make sure only admin users can access" do
    sign_in users(:two)
    get :index
    assert_response :redirect
  end
  
  setup do
    sign_in users(:one)
    @emailing = emailings(:one)
  end
  
  test "should get index for administr8te_emailing" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emailings)
    assert_template "index"
  end
  
  test "should get new administr8te_emailing" do
    get :new
    assert_response :success
    assert_template "new"
  end

  test "should create administr8te_emailing" do
    assert_difference('Emailing.count') do
      post :create, emailing: @emailing.attributes.except("id", "created_at", "updated_at").merge(description: "#{@emailing.description} 2")
    end

    assert_redirected_to administr8te_emailings_path
  end
  
  test "should show administr8te_emailing" do
    get :show, id: @emailing.to_param
    assert_response :success
    assert_template "show"
  end
  
  test "should edit administr8te_emailing" do
    get :edit, id: @emailing.to_param
    assert_response :success
    assert_template "edit"
  end

  test "should update administr8te_emailing" do
    put :update, id: @emailing.to_param, emailing: @emailing.attributes.except("id", "created_at", "updated_at")
    assert_redirected_to administr8te_emailings_path
  end

  test "should destroy administr8te_emailing" do
    assert_difference('Emailing.count', -1) do
      delete :destroy, id: @emailing.to_param
    end

    assert_redirected_to administr8te_emailings_path
  end
end
