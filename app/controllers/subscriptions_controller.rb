class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_plans, :only => [:new, :create]
  
  def new
    @subscription = current_user.subscriptions.build(card_name: 'John Doe', card_number: '5468402944292202')
  end
  
  def create
    @subscription = current_user.subscriptions.build(params[:subscription])
    @subscription.plan = Plan.find_by_name(Settings['subscriptions.default_costing_plan'])
    @subscription.start_date = Time.now
    @subscription.do_validate_card = true
    if @subscription.save
      SubscriptionsMailer.new_subscription_email(@subscription).deliver
      AdminMailer.new_subscription_email(@subscription).deliver
      @subscription.create_audit
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
    @subscription.do_validate_card = true
    if @subscription.valid?
      new_profile_options = @subscription.profile_options.merge(profile_id: @subscription.paypal_profile_id)
      if @subscription.update_profile(new_profile_options)
        SubscriptionsMailer.update_subscription_email(@subscription).deliver
        @subscription.update_audit
        redirect_to success_subscription_url(@subscription), notice: "Your subscription has been successfully updated."
      else
        render action: :edit
      end
    else
      render action: :edit
    end
  end
  
  def cancel
    # cancel on due date
    @subscription = current_user.current_subscription
    if @subscription.cancel(:timeframe => :renewal)
      SubscriptionTransactionsMailer.subscription_cancelled_email(@subscription).deliver
      AdminMailer.cancel_subscription_email(@subscription).deliver
      redirect_to current_subscriptions_url, :notice => "Your subscription has been cancelled successfully."
    else
      redirect_to edit_subscription_url(@subscription), :alert => "Failed to cancel your subscription, please contact system administrator."
    end
  end
  
  def current
    @subscription = current_user.current_subscription
  end
  
  def modify
    @subscription = current_user.subscriptions.build(card_name: 'John Doe', card_number: '5468402944292202')
  end
  
  def reactivate
    puts current_user.inspect
    puts Plan.all.inspect
    @subscription = current_user.current_subscription
    @subscription.assign_attributes(params[:subscription])
    @subscription.do_validate_card = true
    if @subscription.valid?
      if @subscription.modify(params[:subscription].merge(:plan => @subscription.plan, :timeframe => current_user.plan.costing? ? :renewal : :now))
        @subscription.reactivate_audit
        redirect_to current_subscriptions_url, :notice => "Your subscription has been reactivated successfully."
      else
        redirect_to current_subscriptions_url, alert: "Failed to reactivate your subscription, please contact system administrator."
      end
    else
      render :action => :modify
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