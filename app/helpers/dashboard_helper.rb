module DashboardHelper
  def billable_time_grouped_by_date_in_the_last_days(number_of_days = 7)
    time_range = (Time.now.midnight - number_of_days.days)..Time.now.midnight
    projects = current_user.projects.billable.all
    Activity.where(:date => time_range).belonging_to_projects(projects).total_time_grouped_by_date
  end
  
  def billable_hours_on_date(some_date)
    projects = current_user.projects.billable.all
    Activity.where(:date => some_date.to_date).belonging_to_projects(projects).total_time
  end
  
  def unbillable_hours_on_date(some_date)
    projects = current_user.projects.unbillable.all
    Activity.where(:date => some_date.to_date).belonging_to_projects(projects).total_time
  end

  def total_hours_on_date(some_date)
    projects = current_user.projects.all
    Activity.where(:date => some_date.to_date).belonging_to_projects(projects).total_time
  end

  
  def time_pie_chart(billable_hours, unbillable_hours, title = "Chart")
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Type of time')
    data_table.new_column('number', 'Hours')
    data_table.add_rows(5)
    data_table.set_cell(0, 0, 'Billable')
    data_table.set_cell(0, 1, billable_hours)
    data_table.set_cell(1, 0, 'Unbillable')
    data_table.set_cell(1, 1, unbillable_hours)

    opts = { :width => 125, :height => 125, :legend => "none", :tooltipText => "value", :size => '12', :colors => ["#5e6066", "999"], 
           :pieSliceText => "value", :pieSliceTextStyle => {fontSize: '11'}, :backgroundColor => '#fdfdfd', :tooltipTextStyle => {fontSize: '11'} }
    chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)    
  end
  
  def time_pie_chart_on_date(some_date, chart_id)
    billable_hours = billable_hours_on_date(some_date)
    unbillable_hours = unbillable_hours_on_date(some_date)
    if billable_hours > 0 or unbillable_hours > 0
      render_chart time_pie_chart(billable_hours, unbillable_hours, l(some_date.to_date, :format => :short)), chart_id
    else
      content_tag(:div, :class => "empty_pie_chart") do
        content_tag(:div, "")
      end
    end
  end
  
end