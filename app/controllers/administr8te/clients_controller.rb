class Administr8te::ClientsController < Administr8te::BaseController
  set_tab :admin_users
  helper_method :sort_column, :sort_direction
  
  def index
    @users = User.order(sort_column + " " + sort_direction).page(params[:page]).per(10)    
  end
  
  private
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "email"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
