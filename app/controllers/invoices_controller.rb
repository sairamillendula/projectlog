class InvoicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:shared]
  helper_method :sort_column, :sort_direction
  set_tab :invoices

  def index
    @invoices = current_user.invoices.order(sort_column + " " + sort_direction).page(params[:page]).per(10)

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
    @invoice = Invoice.find(params[:id])
    @subject = Settings["invoices.email.subject"].gsub("%{invoice_subject}", @invoice.subject).gsub("%{user_company}", current_user.profile.company)
    @body = Settings["invoices.email.body"].gsub("%{invoice_link}", shared_invoice_url(@invoice.slug))
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    @new_line_item = LineItem.new
    contact = Contact.find(params[:send_invoice][:contact_id])
    attach = if params[:send_invoice][:attach] == "1" then
               render_to_string(:action => 'show.html', :layout => 'pdfattach')
             else
               nil
             end
    InvoicesMailer.invoice_by_email(@invoice, params[:send_invoice][:subject], params[:send_invoice][:body], current_user, contact, attach).deliver
    flash.now[:notice] = "Invoice sent successfully"
    if @invoice.status == "Draft"
      @invoice.status = "Sent"
      @invoice.save
    end
  end

  def show
    @invoice = current_user.invoices.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf { render :text => PDFKit.new(render_to_string(:action => 'show.html', :layout => 'pdfattach')).to_pdf }
    end
  end

  def shared # Like show, except is public for everybody.
    @invoice = Invoice.find_by_slug!(params[:id])
    @skip_approve = true
    respond_to do |format|
      format.html { render :layout => "public" }
      format.pdf { render :text => PDFKit.new(render_to_string(:action => 'show.html', :layout => 'pdfattach')).to_pdf }
    end
  end

  def new
    @invoice = current_user.invoices.new
    @invoice.currency ||= current_user.profile.localization && Localization.find_by_reference(current_user.profile.localization) && Localization.find_by_reference(current_user.profile.localization).currency || "USD"
    @invoice.discount ||= 0
    @invoice.line_items.build(:quantity => 0, :price => 0.0)
    @invoice.note ||= current_user.profile.invoice_signature

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @invoice = current_user.invoices.find(params[:id])
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

  private

  def sort_column
    Invoice.column_names.include?(params[:sort]) ? params[:sort] : "invoice_number"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end