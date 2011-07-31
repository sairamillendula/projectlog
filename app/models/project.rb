class Project < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :customer_id, :unless => :internal?
  validates_uniqueness_of :title, :scope => :user_id
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  
  before_save :clears_if_internal
  
  attr_accessible :title, :description, :status, :default_rate, :customer_id, :billing_code_id, :internal, :billing_estimate
  
  default_scope :order => 'created_at DESC'
  scope :open, where( :status => true )
  scope :closed, where( :status => false )
  scope :billable, where( :internal => false)
  scope :unbillable, where( :internal => true)
  
  # Total hours. Add <%= @project.total_hours %> in Project view
  def total_hours
    activities.sum(:time)
  end    

   # Calculate Project total based on billing_code_id
   def billing_estimate
     if billing_code_id == 1 # Hourly
       self.billing_estimate = total_hours.to_f * default_rate.to_f
     elsif billing_code_id == 2 # Per Diem
       self.billing_estimate = total_hours.to_f / user.profile.hours_per_day.to_f * default_rate.to_f unless user.profile.hours_per_day.nil?
     else
       self.billing_estimate = default_rate # Fixed price
     end
   end
   
   # Clears customer and default rate for internal project
   def clears_if_internal
     if internal?
       self.default_rate = nil
       self.customer_id = nil
     end
   end
end
