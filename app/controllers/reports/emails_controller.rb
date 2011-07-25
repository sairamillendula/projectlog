class Reports::EmailsController < ApplicationController
  def new
    @report = Report.find_by_slug!(params[:report_id])
    @email = Reports::Email.new(:body => Settings["reports.email.body"],
                                :subject => Settings["reports.email.subject"], 
                                :report_link => shared_report_url(@report))
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @email = Reports::Email.new(params[:reports_email].merge(:from => "#{current_user.name} <notification@getprojectlog.com>"))
    if @email.valid?
      @email.deliver
    end
    respond_to do |format|
      format.js
    end
  end
end
