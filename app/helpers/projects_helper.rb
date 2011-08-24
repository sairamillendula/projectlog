module ProjectsHelper
  
  def show_budget
   if @project.billing_code_id.present? && @project.default_rate.present? && @project.total_unit.present? #default_rate and total_unit needed to continue
     @budget = number_to_currency(@project.budget)
    else
      link_to('Edit', edit_project_path(@project))
    end
  end
  
  def show_billable_amount
    if @project.activities.any? && @project.default_rate.present? && @project.total_unit.present? #Calculate if required fields found
      number_to_currency(@project.billable_amount) + ' (' + 
      number_to_percentage(@project.billable_amount / @project.budget.to_f, :precision =>2) + ')'
        
    elsif @project.per_diem? && !current_user.profile.hours_per_day.present? #Can't translate hours to days if variable not set
      link_to('Update settings', settings_path )

    elsif !@project.activities.any? #Nothing to show
    elsif !@project.total_unit.present?
      number_to_currency(@project.billable_amount)
    else  
      link_to('Update your rate', edit_project_path(@project)) unless @project.fixed? #Fixed projects not concerned
    end
  end
  
  #Show user what's left based on budget and total time spent
  def show_unit_left
    if @project.hourly? && @project.total_unit.present?
      number_with_precision(@project.total_unit - @project.total_hours, :precision =>2).to_s
      
    elsif @project.hourly? && !@project.total_unit.present? #Can't determine units left if total not set
      link_to("Edit total hours", edit_project_path(@project))
      
    elsif @project.per_diem? && @project.total_unit.present? && current_user.profile.hours_per_day.present?
      number_with_precision(@project.total_unit - @project.total_hours / current_user.profile.hours_per_day, :precision =>2).to_s
      
    elsif @project.per_diem? && !@project.total_unit.present?
      link_to("Edit total of days", edit_project_path(@project))
      
    elsif @project.per_diem? && !current_user.profile.hours_per_day.present? #Can't translate hours to days if variable not set
      link_to('Update settings', settings_path )
    
    elsif @project.fixed?
    end
  end
  
end
