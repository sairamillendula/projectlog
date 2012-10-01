class InvoicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:shared]
  helper_method :sort_column, :sort_direction
  set_tab :invoices
  before_filter :check_accessible, :only => [:index, :new]
  before_filter :check_limit, :only => [:new]

  def index
    @invoices = current_user.invoices.includes(:customer).order(sort_column + " " + sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def create_line_item
    @line_item = LineItem.new(params[:line_item])
    tax = params[:taxselect].to_i
    subtotal = (@line_item.quantity * @line_item.price).round 2
    utax1 = @line_item.invoice.user.profile.tax1 || 0
    utax2 = @line_item.invoice.user.profile.tax2 || 0
    taxes = 0
    if tax > 0
      if [1, 3].include?(tax) && utax1 > 0
        @line_item.tax1 = (subtotal * utax1 / 100).round(2)
        taxes += @line_item.tax1
      end
      if [2, 3].include?(tax) && utax2 > 0
        @line_item.tax2 = (subtotal * utax2 / 100).round(2)
        taxes += @line_item.tax2
      end
    end
    @line_item.line_total = subtotal + taxes
    if @line_item.save
      respond_to do |format|
        format.html { redirect_to invoice_path(@line_item.invoice), notice: 'Line Item was successfully created.' }
        format.js { @invoice = @line_item.invoice; @new_line_item = LineItem.new }
      end
    else
      render action: "new"
    end
  end

  def delete_line_item
    line_item = LineItem.find(params[:id])
    @id = line_item.id
    invoice = line_item.invoice
    line_item.destroy()
    
    respond_to do |format|
      format.html { redirect_to invoice, notice: 'Line Item was successfully deleted.' }
      format.js { @invoice = invoice; @new_line_item = LineItem.new }
    end
  end

  def prepare_email
    @invoice = Invoice.find_by_slug!(params[:id])
    @subject = Settings["invoices.email.subject"].gsub("%{invoice_subject}", @invoice.subject).gsub("%{user_company}", current_user.profile.company.to_s)
    @body = Settings["invoices.email.body"].gsub("%{invoice_link}", shared_invoice_url(@invoice))
  end

  def send_email
    @invoice = Invoice.includes(:customer, :line_items).find_by_slug!(params[:id])
    @new_line_item = LineItem.new
    recipients = params[:send_invoice][:to].split(",")
    attach = if params[:send_invoice][:attach] == "1" then
               render_to_string(:action => 'show.html', :layout => 'pdfattach')
             else
               nil
             end
    InvoicesMailer.invoice_by_email(@invoice, params[:send_invoice][:subject], params[:send_invoice][:body], current_user, recipients, attach).deliver
    flash.now[:notice] = "Invoice sent successfully"
    @invoice.status = "Sent"
    @invoice.save
    
    respond_to { |format| format.js }
  end

  def show
    @invoice = current_user.invoices.includes(:customer, :line_items).find_by_slug!(params[:id])
    
    respond_to do |format|
      format.html { @is_pdf = false }
      format.pdf { @is_pdf = true; send_data(PDFKit.new(render_to_string(:action => 'show.html', :layout => 'pdfattach')).to_pdf, 
                             :filename => "Invoice #{@invoice.invoice_number}.pdf", 
                             :type => 'application/pdf',
                             :disposition  => "inline") }
    end
  end

  def shared # Like show, except is public for everybody.
    @invoice = Invoice.find_by_slug!(params[:id])
    @skip_approve = true
    
    respond_to do |format|
      format.html { @is_pdf = false; render :layout => "public" }
      # format.pdf { render :text => PDFKit.new(render_to_string(:action => 'show.html', :layout => 'pdfattach')).to_pdf }
      format.pdf { @is_pdf = true; send_data(PDFKit.new(render_to_string(:action => 'shared', :formats => :html, :layout => 'pdfattach')).to_pdf, 
                             :filename => "Invoice #{@invoice.invoice_number}.pdf", 
                             :type => 'application/pdf',
                             :disposition  => "attachment") }
    end
  end

  def new
    @invoice = current_user.invoices.new
    @invoice.prepare_new_invoice

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @invoice = current_user.invoices.find_by_slug!(params[:id])
  end

  def create
    @invoice = current_user.invoices.new(params[:invoice])
    @invoice.status = 'Draft'

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @invoice = current_user.invoices.find_by_slug!(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @invoice = current_user.invoices.find_by_slug!(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
    end
  end
  
  def sort
    params[:line_item].each_with_index do |id, index|
      LineItem.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
  
  def overdue
    @invoices = current_user.invoices.overdue.with_balance.order(sort_column + " " + sort_direction).page(params[:page]).per(10)
    
    respond_to do |format|
      format.js
    end
  end

  def send_reminder_when_due
    @invoice = Invoice.find_by_slug!(params[:id])
    InvoicesMailer.send_reminder_when_due(@invoice).deliver
  end

private

  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "invoice_number"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def check_accessible
    unless current_user.admin?
      unless current_permissions[:invoice][:accessible]
        return redirect_to upgrade_required_subscriptions_url, alert: "You cannot access this page. Please upgrade plan."
      end
    end
  end
  
  def check_limit
    unless current_user.admin?
      if current_permissions[:invoice][:limit] > 0 && current_user.invoices.count >= current_permissions[:invoice][:limit]
        return redirect_to upgrade_required_subscriptions_url, alert: "You have reached max #{current_permissions[:invoice][:limit]} invoices for this plan. Please upgrade plan."
      end
    end
  end

end