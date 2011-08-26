require 'test_helper'

class Administr8te::LogsControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
