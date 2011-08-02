class Administr8te::DashboardController < Administr8te::BaseController
  set_tab :admin_dashboard
  def show
  end
  
  def area_chart
    data_table = GoogleVisualr::DataTable.new
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
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, options)
  end
  
end
