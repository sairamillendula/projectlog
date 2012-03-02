class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @categories = current_user.categories.order(:name).where("lower(name) like ?", "%#{params[:term].downcase}%")
    
    render json: @categories.map(&:name)
  end

  def show
    @category = current_user.categories.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @category = current_user.categories.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def create
    @category = current_user.categories.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to(@category, :notice => 'Category was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def update
    @category = current_user.categories.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(@category, :notice => 'Category was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    
    respond_to do |format|
      format.html { redirect_to categories_url }
    end
  end
  
  def expenses
    @category = current_user.categories.find(params[:id])
    current_period = current_user.profile.fiscal_period
    unless params[:fiscal_year].blank?
      period = Profile.to_period(params[:fiscal_year])
      current_period = period unless period.nil?
    end
    @transactions = @category.transactions.by_period(current_period).order('date DESC')
    @periods = current_user.profile.fiscal_range
    @fiscal_year = Profile.period_to_s(current_period.first, current_period.last)
  end
end