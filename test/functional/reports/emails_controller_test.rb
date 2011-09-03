require 'test_helper'

class Reports::EmailsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @report = reports(:one)
  end

  test "should get new" do
    get :new, :report_id => @report.to_param
    assert_response :success
    assert_template 'new'
  end

  test "should send report by email" do
    Reports::Email.any_instance.expects(:deliver).returns(nil)
    post :create, :format => :js, :report_id => @report.id, :reports_email => {
      :to => "andmej@gmail.com",
      :subject => "Interesting report",
      :body => "Hi, check this out %{report_link}",
      :report_link => "http://getprojectlog.reports/aaaaaaaaaaaaa"
    }
    assert_response :success
  end
end
