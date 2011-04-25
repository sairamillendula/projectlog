class ContactsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_customer
  
  def index
    @customer = Customer.find(params[:customer_id])
    @contacts = @customer.contacts.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    #@customer = Customer.find(params[:customer_id])
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @customer = Customer.find(params[:customer_id])
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def edit
    #@customer = Customer.find(params[:customer_id])
    @contact = Contact.find(params[:id])
  end

  def create
    #@contact = Contact.new(params[:contact])
    #@user = current_user
    #@customer = @user.customers
    #@customer = Customer.find(params[:customer_id])
    #@contact = @customer.contact.new(params[:contact])
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(customers_url, :notice => 'Contact was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js { render 'fail_create.js.erb' }
      end
    end
  end
  
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@user.customers, :notice => 'Contact was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    #@customer = current_user.customers.find(params[:customer_id])
    #@customer = Customer.find(params[:customer_id])
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
    end
  end
  
private
  def load_customer
    @user = current_user
    #@customer = @user.customers.find(params[:customer_id])
    #@customer = current_user.customers.find(params[:customer_id])
    #@customer = Customer.find(params[:customer_id])
  end
end
