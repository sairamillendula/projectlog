class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_plans, :only => [:new, :create]
  
  def new
    @subscription = current_user.subscriptions.build(card_name: 'John Doe', card_number: '5468402944292202')
  end
  
  def create
    @subscription = current_user.subscriptions.build(params[:subscription])
    @subscription.start_date = Time.now
    @subscription.validate_card = true
    if @subscription.save
      redirect_to success_subscription_url(@subscription), :notice => "Your subscription has been successfully updated."
    else
      render :action => :new
    end
  end
  
  def edit
    @subscription = current_user.current_subscription
  end
  
  def update
    @subscription = current_user.current_subscription
    @subscription.assign_attributes(params[:subscription])
    @subscription.validate_card = true
    if @subscription.valid?
      new_profile_options = @subscription.profile_options.merge(profile_id: @subscription.paypal_profile_id)
      if @subscription.update_profile(new_profile_options)
        redirect_to success_subscriptions_url, notice: "Your subscription has been successfully updated."
      else
        render action: :edit
      end
    else
      render action: :edit
    end
  end
  
  def cancel
    # cancel on due date
    subscription = current_user.current_subscription
    if subscription.cancel(:timeframe => :renewal)
      redirect_to current_subscriptions_url, :notice => "Your subscription has been cancelled successfully."
    else
      redirect_to edit_subscription_url(subscription), :alert => "Failed to cancel your subscription, please contact system administrator."
    end
  end
  
  def current
    @subscription = current_user.current_subscription
  end
  
  def reactivate
    subscription = current_user.current_subscription
    subscription.profile_options = {}
    if subscription.reactivate
      redirect_to current_subscriptions_url, :notice => "Your subscription has been reactivated successfully."
    else
      redirect_to current_subscriptions_url, alert: "Failed to reactivate your subscription, please contact system administrator."
    end
  end
  
  def success
    @transaction = current_user.subscriptions.find_by_slug(params[:id])
  end
  
  def receipt
    @subscription = current_user.current_subscription
    @transaction = @subscription.subscription_transactions.find_by_code(params[:code])
    
    respond_to do |format|
      format.pdf { render :text => PDFKit.new(render_to_string(:action => 'receipt.html', :layout => 'pdfattach')).to_pdf }
      format.html
    end
  end
  
private
  
  def load_plans
    @plans = Plan.active.displayable.where("price > 0").order('price ASC') 
  end
end