module ActivitiesHelper

def activities_in_days(total_hours)
  @activities_in_daysa = pluralize( number_with_precision((total_hours) / current_user.profile.hours_per_day, :precision => 2),
                        "day")
end

end
