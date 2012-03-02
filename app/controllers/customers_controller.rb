class CustomersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
  set_tab :customers 
  
  def index
    @customers = current_user.customers.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @customer = current_user.customers.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def edit
    @customer = current_user.customers.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @customer = current_user.customers.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Customer was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def update
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(@customer, :notice => 'Customer was successfully updated.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @customer = current_user.customers.find(params[:id])
    begin
      @customer.destroy
      respond_to do |format|
        format.html { redirect_to customers_url }
      end      
    rescue ActiveRecord::DeleteRestrictionError => e
      respond_to do |format|
        format.html { redirect_to(customer_url(@customer), :alert => 'This customer cannot be deleted because of existing projects/invoices associated') }
      end      
    end
  end
end