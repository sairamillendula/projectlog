class Project < ActiveRecord::Base
  
  validates_presence_of :title, :customer_id
  validates_uniqueness_of :title, :scope => :user_id
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  
  attr_accessible :title, :description, :status, :default_rate, :manager, :customer_id, :billing_code_id, :internal, :billing_estimate
  
  default_scope :order => 'created_at DESC'
  scope :open, where( :status => true )
  scope :closed, where( :status => false )
  scope :billable, where( :internal => false)
  scope :unbillable, where( :internal => true)
  
  #STATUS = [ 'Open', 'Closed' ]
  
  # Total hours. Add <%= @project.total_hours %> in Project view
  def total_hours
    activities.sum(:time)
  end
  
  # Calculate Project total based on billing_code_id
  def billing_estimate
    if billing_code_id == 1 # Hourly
      @billing_estimate = "#{total_hours} * #{default_rate}"
    elsif billing_code_id == 2 # Per Diem
      @billing_estimate = total_hours * @current_user.profile.hours_per_day
    else
      @billing_estimate = default_rate # Fixed price
    end
  end
  
end
