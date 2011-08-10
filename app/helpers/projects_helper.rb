module ProjectsHelper
  
  def unit_left
    if @project.billing_code_id == 1 && @project.total_unit.present?
      (@project.total_unit - @project.total_hours).to_s
    elsif @project.billing_code_id == 1 && !@project.total_unit.present?
      "Total hours not set"
    elsif @project.billing_code_id == 2 && @project.total_unit.present? && current_user.profile.hours_per_day.present?
      number_with_precision(@project.total_unit - @project.total_hours / current_user.profile.hours_per_day, :precision =>2).to_s # BUG!!!!!
    elsif @project.billing_code_id == 2 && !@project.total_unit.present?
      "Total days not set"
    elsif @project.billing_code_id == 2 && !current_user.profile.hours_per_day.present?
      "Not set"
    end
  end
  
end
