class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_user

  def edit
    @profile = current_user.profile
  end

  def create
    @profile = current_user.build_profile(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to(@profile, :notice => 'Profile was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @profile = current_user.profile
    @logo_file_url = @profile.logo.url(:thumb)

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(settings_path, :notice => 'Settings were successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @profile = current_user.profile
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
    end
  end
end