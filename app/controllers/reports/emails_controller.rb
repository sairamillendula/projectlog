class Reports::EmailsController < ApplicationController
  def new
    @report = Report.find_by_slug!(params[:report_id])
    @email = Reports::Email.new(:body => "Hello,\n\nTake a look at this report: #{shared_report_url(@report)}\n\nTalk soon,\n\n#{current_user.name}", :subject => "I want to share this report with you", :report_link => shared_report_url(@report))
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @email = Reports::Email.new(params[:reports_email].merge(:from => current_user.name_with_email))
    if @email.valid?
      @email.deliver
    end
    respond_to do |format|
      format.js
    end
  end
end
