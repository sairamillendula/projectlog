module DashboardHelper
  def billable_time_grouped_by_date_in_the_last_days(number_of_days = 7)
    time_range = (Time.now.midnight - number_of_days.days)..Time.now.midnight
    projects = current_user.projects.billable.all
    Activity.where(:date => time_range).belonging_to_projects(projects).total_time_grouped_by_date
  end
end
