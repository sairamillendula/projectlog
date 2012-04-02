class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  set_tab :projects
  before_filter :check_accessible, :only => [:index, :new]
  before_filter :check_limit, :only => [:new]
  
  def index
    return redirect_to upgrade_required_subscriptions_url, notice: "You cannot access this page. Please upgrade plan." unless current_permissions[:project][:accessible]
    
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
      format.js
    end
  end
  
  def quick
    @project = current_user.projects.new
    
    respond_to do |format|
      format.js
    end
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def create
    @project = current_user.projects.build
    @project.assign_attributes(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
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
    current_period = current_user.profile.fiscal_period
    unless params[:fiscal_year].blank?
      period = Profile.to_period(params[:fiscal_year])
      current_period = period unless period.nil?
    end
    @transactions = @project.transactions.by_period(current_period).order('date DESC')
    @periods = current_user.profile.fiscal_range
    @fiscal_year = Profile.period_to_s(current_period.first, current_period.last)
  end
  
private
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def check_accessible
    unless current_user.admin?
      unless current_permissions[:project][:accessible]
        return redirect_to upgrade_required_subscriptions_url, alert: "You cannot access this page. Please upgrade plan."
      end
    end
  end
  
  def check_limit
    unless current_user.admin?
      if current_permissions[:project][:limit] > 0 && current_user.projects.count >= current_permissions[:project][:limit]
        return redirect_to upgrade_required_subscriptions_url, alert: "You have reached max #{current_permissions[:project][:limit]} projects for this plan. Please upgrade plan."
      end
    end
  end
  
end