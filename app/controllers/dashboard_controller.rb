class DashboardController < ApplicationController
  before_filter :authenticate_user!  
  set_tab :dashboard
  
  def billable_acti
    time_range = (Time.now.midnight - 7.days)..Time.now.midnight
    p = current_user.projects.billable
    @billable_acti= Activity.where(:date => time_range).where(:project_id => p).group("date(date)").sum(:time)
  end
  
  def message
    @message = 'Bravo'
  end
  
end
