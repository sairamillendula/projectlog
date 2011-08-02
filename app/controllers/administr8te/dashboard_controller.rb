class Administr8te::DashboardController < Administr8te::BaseController
  set_tab :admin_dashboard
  def show
    
    @s_count = User.standard.group("date(created_at)").select("created_at, count(id) as count_users").size
    #@s_count = User.standard.count

    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers 
    data_table.new_column('date', 'Day' ) 
    data_table.new_column('number', 'Total Count') 

    # Add Rows and Values 
    data_table.add_rows([ 
      [Date.parse('2011-08-02'), @s_count]
    ])

    option = { width: 880, height: 240, title: 'Signup per day' }
    @users_chart = GoogleVisualr::Interactive::LineChart.new(data_table, option)
    
  end

end
