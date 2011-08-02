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
  end

end
