require 'test_helper'

class Administr8te::SettingsControllerTest < ActionController::TestCase
  test "should not get edit if not admin" do
    sign_in users(:two)
    get :edit
    assert_response :redirect
  end
  
  setup do
    sign_in users(:one)
  end

  test "should get edit" do
    get :edit
    assert_response :success
    assert_template 'edit'
  end
  
  test "should update administr8te_settings" do
    @setting = Settings["reports.email.subject"]
  end
  
end
