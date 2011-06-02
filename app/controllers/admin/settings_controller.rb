class Admin::SettingsController < ApplicationController
  before_filter :require_admin
  def edit
  end
  
  def update
    params[:settings].each do |name, value|
      Settings[name] = value
    end
    redirect_to edit_admin_settings_path, :notice => "Your settings have been saved."
  end
end
