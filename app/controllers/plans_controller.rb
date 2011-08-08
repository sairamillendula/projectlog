# This controller is used for upgrading/downgrading users' plans.
class PlansController < ApplicationController
  before_filter :authenticate_user!
  
  def edit
    @plans = Plan.active.all
  end
  
  def update
    @plan = Plan.find(params[:plan_id])
    @user = current_user
    @user.plan = @plan
    @current_user.save!
    redirect_to edit_plan_path, :notice => "Your plan has been updated!"
  end
end
