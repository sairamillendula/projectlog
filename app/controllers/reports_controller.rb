# encoding: utf-8
require 'iconv'
class ReportsController < ApplicationController
  before_filter :authenticate_user!, :except => [:shared, :approve ]
  set_tab :reports
  helper_method :sort_column, :sort_direction
  
  def new
    @report = Report.new
  end
  
  def create
    @report = current_user.reports.new(params[:report])
    if @report.save
      redirect_to @report
    else
      render "new"
    end
  end
  
  def show
    @report = Report.find_by_slug!(params[:id])
    @activities = @report.activities.search(params[:search]).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.html { @activities = @activities.page(params[:page]).per(10) }
      format.js { @activities = @activities.page(params[:page]).per(10) }
    end
  end
  
  def shared # Like show, except is public for everybody.
    @report = Report.find_by_slug!(params[:id])
    @activities = @report.activities.order('date ASC')
    respond_to do |format|
      format.html do
        render :layout => "public"
      end
      format.pdf { render :text => PDFKit.new(render_to_string).to_pdf }
      format.csv { 
        content = @report.to_csv
        content = Iconv.conv('ISO-8859-15','UTF-8', content)
        send_data content, 
          :filename => "time_entries.csv", 
          :type => 'text/csv; charset=utf-8; header=present',
          :disposition => "attachment"
      }
    end
  end
  
  def approve
    @report = Report.find_by_slug!(params[:id])

    if !@report.approved?
      @report.approve!(request.remote_ip)

      if @report.save
        redirect_to shared_report_path(@report)
      else
        redirect_to shared_report_path(@report), :notice => 'An error occured. Please try again.'
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end 
  end
  
private
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end