class Reports::EmailsController < ApplicationController
  def new
    @report = Report.find_by_slug!(params[:report_id])
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
