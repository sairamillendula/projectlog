module ReportsHelper
  def last_months_select(field_name, options = {}, how_many_months = 12)
    select_tag(field_name, last_months_select_options(how_many_months, options), options)
  end
  
  def last_months_select_options(how_many_months, options)
    first_day_of_current_month = Date.today.beginning_of_month
    array = (0...how_many_months).collect { |i| [(first_day_of_current_month - i.months).strftime("%B %Y"), first_day_of_current_month - i.months] }
    options_for_select(array, :selected => options[:selected] || first_day_of_current_month)
  end
  
  def report_project_select(field_name, projects, options = {})
    select_tag(field_name, options_for_select([["all projects", ""]] + projects.collect { |project| [project.title, project.id] }, options[:selected]), options)
  end
end
