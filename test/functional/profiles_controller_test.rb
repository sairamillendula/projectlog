require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @profile = profiles(:one)
    sign_in @user
  end

  test "should create profile" do
    @user.profile = nil
    @user.save!
    assert_difference('Profile.count') do
      post :create, :profile => @profile.attributes.except("id", "created_at", "updated_at", "last_invoice")
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should get edit" do
    get :edit, :id => @profile.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update profile" do
    put :update, :id => @profile.to_param, :profile => @profile.attributes.except("id", "created_at", "updated_at", "last_invoice")
    assert_redirected_to settings_path
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, :id => @profile.to_param
    end

    #assert_redirected_to profiles_path
  end
end
