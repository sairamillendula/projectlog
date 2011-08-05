module Administr8te::DashboardHelper

  # An Active User is a person who signed in within the last 3 months has at least 1 project and at least 5 activities
  def active_users
    #@active_users = User.where(:admin => false AND "last_sign_in_at < ?, 3.months.ago" ).includes(:activities).size
    #@active_users = User.standard.where("last_sign_in_at > ?", 3.months.ago).size
    #@active_users_with_activities = @active_users.activities_i.any?
    @active_users = User.standard.joins(:projects).group('"projects"."user_id"').having('COUNT(projects.id) > 1').size
  end
  
  def average_projects_per_user
    @projects_belonging_to_standard_users = User.standard.joins(:projects).all.size
    @average_projects_per_user = @projects_belonging_to_standard_users.to_f / User.standard.size.to_f
  end
  
  def average_subscription_time_in_days
    users = User.standard.all
    average_subscription = average(Date.today  -  users.created_at.to_date).to_i
  end
  
  def total_users_created(timeframe)
    @total_users_created = User.standard.where("created_at > ?", timeframe).size
  end
  
  def users_chart_series(users, start_time)
    users_by_day = users.where(:created_at => start_time.beginning_of_day..Time.zone.now.end_of_day).
                   group("date(created_at)").
                   select("created_at, count(id) as total_users")
    (start_time.to_date..Date.today).map do |date|
      user = users_by_day.detect { |user| user.created_at.to_date == date }
      user && user.total_users.to_i || 0
    end.inspect
  end
  
end
