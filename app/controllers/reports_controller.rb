class ReportsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  set_tab :reports
  helper_method :sort_column, :sort_direction
  before_filter :send_timesheet
  
  def new
    @report = Report.new
  end
  
  def create
    @report = current_user.reports.new(params[:report])
    @report.start_date ||= Date.today.beginning_of_month
    @report.end_date ||= @report.start_date + 1.month
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
      format.pdf { render :text => PDFKit.new(render_to_string).to_pdf }
      format.csv      
    end
  end
  
  def send_timesheet
    
  end
  
  private
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end