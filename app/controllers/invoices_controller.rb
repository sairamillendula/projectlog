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

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = current_user.invoices.find(params[:id])
    @new_line_item = LineItem.new
  end

  def new
    @invoice = current_user.invoices.new
    @invoice.invoice_number ||= @invoice.generate_invoice_number
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