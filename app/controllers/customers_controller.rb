class CustomersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
  set_tab :customers 
  
  def index
    @customers = @user.customers.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @customer = @user.customers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @customer = current_user.customers.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def create
    @customer = @user.customers.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Customer was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(@customer, :notice => 'Customer was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
    end
  end  

 def projects
   @customer = current_user.customers.all
   @projects = @customer.projects.all
 end
 
end
