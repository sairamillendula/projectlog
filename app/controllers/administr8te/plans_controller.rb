class Administr8te::PlansController < ApplicationController
  before_filter :require_admin
  set_tab :admin_plans

  def index
    @administr8te_plans = Administr8te::Plan.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @administr8te_plan = Administr8te::Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @administr8te_plan = Administr8te::Plan.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @administr8te_plan = Administr8te::Plan.find(params[:id])
  end

  def create
    @administr8te_plan = Administr8te::Plan.new(params[:administr8te_plan])

    respond_to do |format|
      if @administr8te_plan.save
        format.html { redirect_to @administr8te_plan, notice: 'Plan was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @administr8te_plan = Administr8te::Plan.find(params[:id])

    respond_to do |format|
      if @administr8te_plan.update_attributes(params[:administr8te_plan])
        format.html { redirect_to @administr8te_plan, notice: 'Plan was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @administr8te_plan = Administr8te::Plan.find(params[:id])
    @administr8te_plan.destroy

    respond_to do |format|
      format.html { redirect_to administr8te_plans_url, notice: 'Plan was successfully deleted.' }
    end
  end
end