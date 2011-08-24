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
  
  def after_sign_in_path_for(user)
    if pending_announcement = Announcement.current_announcement_for(user)
      announcement_path(pending_announcement)
    else
      user.admin? ? administr8te_dashboard_path : super
    end
  end
  
  def set_locale
    if user_signed_in? && current_user.profile.localization.present?
      I18n.locale = current_user.profile.localization      
    end
  end

  def require_admin
    redirect_to root_path, :alert => "Access denied" unless user_signed_in? && current_user.admin?
  end
  
  def store_location(return_to = request.path)
    session[:return_to] = return_to
  end
  
  def store_location_and_redirect_to(new_location)
    store_location
    redirect_to new_location
  end
  
  def redirect_to_stored_location_or_default(default = root_path)
    redirect_to session.delete(:return_to) || default
  end
end
