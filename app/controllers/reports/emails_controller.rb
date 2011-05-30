class Reports::EmailsController < ApplicationController
  def new
    @report = Report.find_by_slug!(params[:report_id])
    @email = Reports::Email.new(:body => "Hello", :subject => "I want to share this report with you", :report_link => shared_report_url(@report))
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @email = Reports::Email.new(params[:reports_email].merge(:from => current_user.name_with_email))
    if @email.valid?
      # TODO: Send the real email here.
    end
    respond_to do |format|
      format.js
    end
  end
end
