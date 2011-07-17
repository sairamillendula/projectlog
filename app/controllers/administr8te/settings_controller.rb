class Administr8te::SettingsController < Administr8te::BaseController
  def edit
  end
  
  def update
    params[:settings].each do |name, value|
      Settings[name] = value
    end
    redirect_to edit_administr8te_settings_path, :notice => "Settings have been saved."
  end

end
