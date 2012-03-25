class Administr8te::SubscriptionsController < Administr8te::BaseController
  set_tab :admin_subscriptions
  helper_method :sort_column, :sort_direction
  
  def index
    @subscriptions = SubscriptionTransaction.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10) 
  end
  
private
  def sort_column
    SubscriptionTransaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end