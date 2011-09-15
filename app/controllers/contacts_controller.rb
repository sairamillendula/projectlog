class ContactsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @customer = current_user.customers.find(params[:customer_id])
    @contacts = @customer.contacts.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def edit
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])
  end

  def create
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.new(params[:contact])
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@customer, :notice => 'Contact was successfully created.') }
        format.js 
      else
        format.html { redirect_to @customer, :alert => 'Unable to add contact' }
        format.js
      end
    end
  end

  def update
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])
    
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@customer, :notice => 'Contact was successfully updated.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @customer = current_user.customers.find(params[:customer_id])
    @contact = @customer.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(@customer, :notice => 'Contact deleted') }
    end
  end
end