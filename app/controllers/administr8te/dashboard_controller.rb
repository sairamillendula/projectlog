class Administr8te::DashboardController < Administr8te::BaseController
  set_tab :admin_dashboard
  def show
    data_table = GoogleVisualr::DataTable.new
    
    @users = User.standard.all
    
    data_table.new_column('string', 'Year')
    data_table.new_column('number', 'Sales')
    data_table.new_column('number', 'Expenses')
    data_table.add_rows( [
        ['2004', 1000, 400],
        ['2005', 1170, 460],
        ['2006', 660, 1120],
        ['2007', 1030, 540]
      ])

    options   = { width: 400, height: 240, title: 'Company Performance', hAxis: {title: 'Year', titleTextStyle: {color: '#FF0000'}} }
    @users_chart = GoogleVisualr::Interactive::LineChart.new(data_table, options)
    
    
    @s_count = User.standard.group("date(created_at)").count
    #@s_count = User.standard.count

    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers 
    data_table.new_column('string', 'Date' ) 
    data_table.new_column('number', 'Total Count') 

    # Add Rows and Values 
    data_table.add_rows([ 
      ['date', @s_count]
    ])

    option = { width: 880, height: 240, title: 'Signup per day' }
    @chart2 = GoogleVisualr::Interactive::LineChart.new(data_table, option)
    
  end

end
