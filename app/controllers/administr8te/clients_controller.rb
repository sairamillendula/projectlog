class Administr8te::ClientsController < Administr8te::BaseController
  set_tab :admin_users
  helper_method :sort_column, :sort_direction
  
  def index
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10)    
  end
  
  def summary
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def profile
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def transactions
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
