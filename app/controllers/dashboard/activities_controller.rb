class Dashboard::ActivitiesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @project = current_user.projects.find(params[:project_id])
    @activities = @project.activities.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
      format.js
    end
  end

  def show
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  def new
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
      format.js
    end
  end

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
