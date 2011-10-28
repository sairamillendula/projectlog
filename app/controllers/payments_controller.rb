# encoding: utf-8
class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payments = @invoice.payments
    @total = @payments.sum(:amount).round 2
  end

  def new
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payment = Payment.new
    @payment.invoice = @invoice
    @payment.amount = @invoice.amount_due
    @refresh = if params[:update_payments] == 'yes' then true else false end
  end

  def create
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payment = Payment.new(params[:payment])
    @payment.invoice = @invoice
    if @payment.save
      update_invoice
      if params[:update_payments] == 'yes'
        @refresh = true
        @payments = @invoice.payments
        @total = @invoice.balance
      else
        @refresh = false
      end
    end
  end

  def edit
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payment = @invoice.payments.find(params[:id])
  end

  def update
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payment = @invoice.payments.find(params[:id])
    if @payment.update_attributes(params[:payment])
      update_invoice
      @payments = @invoice.payments
      @total = @invoice.balance
    end
  end

  def destroy
    @invoice = current_user.invoices.find(params[:invoice_id])
    @payment = @invoice.payments.find(params[:id])
    if @payment.destroy
      update_invoice
      @payments = @invoice.payments
      @total = @invoice.balance
    end
  end

  private

  def update_invoice
    @invoice.balance = @invoice.payments.sum(:amount).round 2
    @invoice.status = if @invoice.amount_due > 0.01 then "partial payment" else "paid" end
    @invoice.save
  end
end