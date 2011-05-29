class Reports::EmailsController < ApplicationController
  def new
    @report = Report.find_by_slug!(params[:report_id])
    @email = Reports::Email.new(:from => current_user.name_with_email, :to => current_user.connections.collect { |c| c.name_with_email }.compact.join(", "), :body => "Hello", :subject => "I want to share this report with you")
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    respond_to do |format|
      format.js
    end
  end
end
