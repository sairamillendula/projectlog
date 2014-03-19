# encoding: UTF-8

class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  set_tab :accounting

  before_filter :check_accessible, :only => [:index, :new]
  before_filter :check_limit, :only => [:new]

  def index
    @transactions = current_user.transactions.includes(:project, :category).order(sort_column + " " + sort_direction).page(params[:page]).per(20)
    @transactions = @transactions.by_keyword(params[:search]) unless params[:search].blank?
    @transactions = @transactions.by_category(params[:category_id]) unless params[:category_id].blank?
    if !params[:start_date].blank? and !params[:end_date].blank?
      @transactions = @transactions.by_period((params[:start_date]..params[:end_date]))
    elsif !params[:start_date].blank?
      @transactions = @transactions.from_date(params[:start_date])
    elsif !params[:end_date].blank?
      @transactions = @transactions.to_date(params[:end_date])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
      format.js
      format.csv {
        content = Transaction.to_csv(current_user.transactions.includes(:project, :category))
        content = content.encode("UTF-8")
        send_data content,
          filename:    "transactions.csv",
          type:        "text/csv; charset=utf-8; header=present",
          disposition: "attachment"
      }
    end
  end

  def show
    @transaction = current_user.transactions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  def new
    @transaction = current_user.transactions.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
      format.js
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
      format.js
    end
  end

  def create
    @transaction = current_user.transactions.build
    @transaction.assign_attributes(params[:transaction])
    @is_quick = params[:quick].present?
    respond_to do |format|
      if @transaction.save
        @transactions = current_user.transactions.order("created_at DESC").page(1).per(20)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render json: @transaction, status: :created, location: @transaction }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    @transaction = current_user.transactions.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :ok }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @transaction = current_user.transactions.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :ok }
    end
  end

  def monthly_report
    current_period = current_user.profile.fiscal_period
    unless params[:fiscal_year].blank?
      period = Profile.to_period(params[:fiscal_year])
      current_period = period unless period.nil?
    end
    @transactions = current_user.transactions.by_period(current_period).includes(:category, :project).order("date DESC")
    @periods = current_user.profile.fiscal_range
    @fiscal_year = Profile.period_to_s(current_period.first, current_period.last)
  end

  def find_by_note
    @transactions = current_user.transactions.order(:note).where("lower(note) like ?", "%#{params[:term].downcase}%")

    render json: @transactions.map(&:note).uniq
  end

private

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def check_accessible
    unless current_user.admin?
      unless current_permissions[:transaction][:accessible]
        return redirect_to upgrade_required_subscriptions_url, alert: "You cannot access this page. Please upgrade plan."
      end
    end
  end

  def check_limit
    unless current_user.admin?
      if current_permissions[:transaction][:limit] > 0 && current_user.transactions.count >= current_permissions[:transaction][:limit]
        return redirect_to upgrade_required_subscriptions_url, alert: "You have reached max #{current_permissions[:transaction][:limit]} transactions for this plan. Please upgrade plan."
      end
    end
  end

end
