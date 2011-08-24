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
    @total_users_created = User.standard.where("users.created_at > ?", timeframe).size
  end
  
  def total_users_with_free_plan_created(timeframe)
    @total_users_with_free_plan_created = User.standard.with_free_plan.where("users.created_at > ?", timeframe).size
  end
  
  def total_users_with_paid_plan_created(timeframe)
    @total_users_with_paid_plan_created = User.standard.with_paid_plan.where("users.created_at > ?", timeframe).size
  end
  
  def signups_in_the_last_month_chart(container_dom_id)
    users = User.standard.where("`users`.created_at > ?", 31.days.ago).select("created_at")
    counts = {}
    users.each do |user|
      counts[user.created_at.to_date] ||= 0
      counts[user.created_at.to_date] += 1
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table.new_column('number', 'New users')
    data_table.add_rows(31)
    0.upto(30) do |i|
      date = (30 - i).days.ago.to_date

      data_table.set_cell(i, 0, l(date, :format => :short))
      data_table.set_cell(i, 1, counts[date] || 0)
    end

    opts = { :width => 880, :height => 200, :title => 'Signups in the last 31 days', :legend => 'none', :colors => ['#f26535'], 
           :backgroundColor => '#fdfdfd', :hAxis => { :textStyle => { :color => "black", :fontName => "Arial", :fontSize => 12 } } }
    render_chart GoogleVisualr::Interactive::LineChart.new(data_table, opts), container_dom_id
  end
end
