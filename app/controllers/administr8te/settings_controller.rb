class Administr8te::SettingsController < ApplicationController
  before_filter :require_admin
  def edit
  end
  
  def update
    params[:settings].each do |name, value|
      Settings[name] = value
    end
    redirect_to edit_administr8te_settings_path, :notice => "Settings have been saved."
  end

end