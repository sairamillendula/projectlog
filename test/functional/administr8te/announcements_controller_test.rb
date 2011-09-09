require 'test_helper'

class Administr8te::AnnouncementsControllerTest < ActionController::TestCase
  test "should not get index if not admin" do
    sign_in users(:two)
    get :index
    assert_response :redirect
  end
  
  setup do
    sign_in users(:one)
    @announcement = announcements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:announcements)
    assert_template 'index'
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "should create announcement" do
    assert_difference('Announcement.count') do
      post :create, announcement: @announcement.attributes.merge(message: "#{@announcement.message} Backup next week")
    end

    assert_redirected_to administr8te_announcement_path(assigns(:announcement))
  end

  test "should show administr8te_announcement" do
    get :show, id: @announcement.to_param
    assert_response :success
    assert_template 'show'
  end

  test "should get edit" do
    get :edit, id: @announcement.to_param
    assert_response :success
    assert_template 'edit'
  end

  test "should update administr8te_announcement" do
    put :update, id: @announcement.to_param, announcement: @announcement.attributes
    assert_redirected_to administr8te_announcement_path(assigns(:announcement))
  end

  test "should destroy administr8te_announcement" do
    assert_difference('Announcement.count', -1) do
      delete :destroy, id: @announcement.to_param
    end

    assert_redirected_to administr8te_announcements_path
  end
  

end
