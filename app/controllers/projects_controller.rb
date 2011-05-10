class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  set_tab :projects
  
  def index
    @open_projects = current_user.projects.page(params[:page]).per(6)
    @closed_projects = current_user.projects.closed.all.paginate(:page => 2, :page => params[:page] )

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @project = current_user.projects.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def create
    @project = current_user.projects.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
    end
  end
end