class ContactsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :load_customer
  
  def index
    @customer = Customer.find(params[:customer_id])
    @contacts = @customer.contacts.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @customer = Customer.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    #@contact = Contact.new
    @customer = Customer.find(params[:customer_id])
    @contact = @customer.contacts.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @customer = Customer.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @contact = @customer.contacts.new(params[:contact])
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(customers_url, :notice => 'Contact was successfully created.') }
        format.js 
      else
        respond_to do |format|
        format.html { redirect_to @customer, :alert => 'Unable to add contact' }
        format.js { render 'fail_create.js.erb' }
      end
    end
  end
  
  def update
    @customer = Customer.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@customer, :notice => 'Contact was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    #@customer = Customer.find(params[:customer_id])
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url, :notice => 'Contact deleted') }
    end
  end
  
end
end