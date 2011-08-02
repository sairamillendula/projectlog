module Administr8te::DashboardHelper

  # An Active User is a person who signed in within the last 3 months has at least 1 project and at least 5 activities
  def active_users
    #@active_users = User.where(:admin => false AND "last_sign_in_at < ?, 3.months.ago" ).includes(:activities).size
    #@active_users = User.standard.where("last_sign_in_at > ?", 3.months.ago).size
    #@active_users_with_activities = @active_users.activities_i.any?
    @active_users = User.where(:admin => false).joins(:projects).group('"projects"."user_id"').having('COUNT(projects.id) > 5').size
  end
  
  def total_users_created(timeframe)
    @total_users_created = User.standard.where("created_at > ?", timeframe).size
  end
  
end
