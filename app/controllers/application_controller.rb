class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  
private
  def load_user
    @user = current_user
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(user)
    login_path
  end
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = current_user.profile.localization if user_signed_in?
  end

  def require_admin
    redirect_to root_path, :alert => "Access denied" unless user_signed_in? && current_user.admin?
  end
  
end
