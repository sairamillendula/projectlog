class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  set_tab :projects
  
  def index
    @open_projects = current_user.projects.scoped.open.page(params[:page]).per(6)
    @closed_projects = current_user.projects.closed.page(1).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
  
  # Show only closed projects
  def closed
    @closed_projects = current_user.projects.closed.page(params[:page]).per(10)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @project = current_user.projects.includes(:customer).find(params[:id])
    @activities = @project.activities.order(sort_column + " " + sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @project = current_user.projects.new
    @project.customer = current_user.customers.find_by_id(params[:customer_id])
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
      format.html { redirect_to projects_url }
    end
  end
  
  def expenses
    @project = current_user.projects.find(params[:id])
    @transactions = @project.transactions.order('date DESC')
  end
  
private
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end