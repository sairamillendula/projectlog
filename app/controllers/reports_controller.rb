class ReportsController < ApplicationController
  before_filter :authenticate_user!
  set_tab :reports
  helper_method :sort_column, :sort_direction
  
  def index
  end
    
  def search
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : start_date + 1.month
    @projects = params[:project_id].present? ? [current_user.projects.find(params[:project_id])] : current_user.projects.all
    @activities = current_user.activities.after(start_date).
                                          before(end_date).
                                          search(params[:search]).
                                          order(sort_column + " " + sort_direction).
                                          belonging_to_projects(@projects)
    @total_time = @activities.sum(:time) # Calculate time before pagination.
    respond_to do |format|
      format.js { @activities = @activities.page(params[:page]).per(10) }
      format.pdf { render :text => PDFKit.new(render_to_string).to_pdf }
      format.csv
    end
  end
  
  private
  
  private
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
