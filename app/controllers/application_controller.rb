class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  before_filter :redirect_to_current_announcement
  
private
  def load_user
    @user = current_user
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(user)
    login_path
  end
  
  def after_sign_in_path_for(user)
    user.admin? ? administr8te_dashboard_path : super
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
  
  def redirect_to_current_announcement
    return unless user_signed_in? # Do nothing if we are not signed in
    for announcement in Announcement.current_announcements
        next if announcement.hidden_by?(current_user)
        # Announcement is not hidden. Let's redirect to it.
        store_location_and_redirect_to(announcement) and return
    end
  end
end
