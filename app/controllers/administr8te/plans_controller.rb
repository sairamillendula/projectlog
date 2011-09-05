# This controller is used for managing plans available for people.
class Administr8te::PlansController < Administr8te::BaseController
  set_tab :admin_plans

  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def create
    @plan = Plan.new(params[:plan])

    respond_to do |format|
      if @plan.save
        format.html { redirect_to administr8te_plan_path(@plan), notice: 'Plan was successfully created.' }
      else
        puts @plan.errors.full_messages.to_sentence
        format.html { render action: "new" }
      end
    end
  end

  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to administr8te_plan_path(@plan), notice: 'Plan was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to administr8te_plans_url, notice: 'Plan was successfully deleted.' }
    end
  end
end


