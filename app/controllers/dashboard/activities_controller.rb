class Dashboard::ActivitiesController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @activity = current_user.activities.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @project = current_user.projects.find_by_id(params[:project_id])
    @activity = @project.blank? ? current_user.activities.new(params[:activity]) : @project.activities.new(params[:activity])
    @activity.save
    respond_to { |format| format.js }
  end

  def update
    @activity = current_user.activities.find(params[:id])
    @activity.update_attributes(params[:activity])
    respond_to { |format| format.js }
  end

  def destroy
    @activity = current_user.activities.find(params[:id])
    @activity.destroy
    respond_to { |format| format.js }
  end
end
