class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction  
  set_tab :invoices
  
  def index
    @invoices = current_user.invoices.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @invoice = current_user.invoices.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @invoice = current_user.invoices.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @invoice = current_user.invoices.find(params[:id])
  end

  def create
    @invoice = current_user.invoices.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @invoice = current_user.invoices.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @invoice = current_user.invoices.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
    end
  end
end