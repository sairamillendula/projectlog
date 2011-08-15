class AnnouncementsController < ApplicationController
  skip_before_filter :redirect_to_current_announcement
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def show
  end
  
  def hide
    @announcement.hide_for!(current_user)
    redirect_to_stored_location_or_default
  end
end
