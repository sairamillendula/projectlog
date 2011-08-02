module Administr8te::ClientsHelper
 
  def total_users_created(timeframe)
    @total_users_created = User.standard.where("created_at > ?", timeframe).size
  end
  
end
