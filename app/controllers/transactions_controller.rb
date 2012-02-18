class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  set_tab :accounting
  
  def index
    @transactions = current_user.transactions.order(sort_column + " " + sort_direction).page(params[:page]).per(20) 
    @transactions = @transactions.by_keyword(params[:search]) unless params[:search].blank?
    @transactions = @transactions.by_category(params[:category_id]) unless params[:category_id].blank?
    if !params[:start_date].blank? and !params[:end_date].blank?
      @transactions = @transactions.by_period(params[:start_date], params[:end_date])
    elsif !params[:start_date].blank?
      @transactions = @transactions.from_date(params[:start_date])
    elsif !params[:end_date].blank?
      @transactions = @transactions.to_date(params[:end_date])
    end
    # search(params[:search]).
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
      format.js
      format.csv { response.headers["Content-Disposition"] = "attachment; filename=transactions.csv" }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = current_user.transactions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = current_user.transactions.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
      format.js
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = current_user.transactions.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create
    # @transaction = current_user.transactions.build(params[:transaction])
    @transaction = current_user.transactions.build
    @transaction.assign_attributes(params[:transaction])

    respond_to do |format|
      if @transaction.save
        @transactions = current_user.transactions.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(20)
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

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = current_user.transactions.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = current_user.transactions.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :ok }
    end
  end
  
  def monthly_report
    @transactions = current_user.transactions.order("date DESC")
  end
  
  private
  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end