module ActivitiesHelper

  def activities_to_days(total_hours)
    @activities_to_days = "[" + pluralize( number_with_precision((total_hours) / current_user.profile.hours_per_day, :precision => 2 ),
                          "day") + "]" unless (current_user.profile.hours_per_day.nil?)
  end

end
