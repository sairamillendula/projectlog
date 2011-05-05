class ReportsController < ApplicationController
  before_filter :authenticate_user!
  set_tab :reports
  
  def index
    @projects = current_user.projects.all
    @activities = current_user.activities.all
  end
  
  # Create Timesheet report with floexible criteria select for input
  
end
