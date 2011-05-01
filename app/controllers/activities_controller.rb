class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @project = current_user.projects.find(params[:project_id])
    @activities = @project.activities.all.paginate(:per_page => 2, :page => params[:page] )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
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
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.find(params[:id])
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.new(params[:activity])

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(@project, :notice => 'Activity was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @activity }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(@project, :notice => 'Activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @activity = @project.activities.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(@project) }
      format.xml  { head :ok }
    end
  end

  # def total
  #     @project = current_user.projects.find(params[:project_id])
  #     @activities = @project.activities.all.sum(&:time)
  #   end
end
