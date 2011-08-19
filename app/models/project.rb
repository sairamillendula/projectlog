class Project < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :customer_id, :unless => :internal?
  validates_uniqueness_of :title, :scope => :user_id
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  
  before_save :clears_if_internal
  
  attr_accessible :title, :description, :status, :default_rate, :customer_id, :billing_code_id, :internal, :total_unit, :budget, :billable_amount,
                  :unit_left
  
  scope :open, where(:status => true)
  scope :closed, where(:status => false)
  scope :billable, where(:internal => false)
  scope :unbillable, where(:internal => true)
  scope :hourly, lambda { where(:billing_code_id => BillingCode.find_by_name!("Hourly").id) }
  scope :per_diem, lambda { where(:billing_code_id => BillingCode.find_by_name!("Per Diem").id) }
  scope :fixed, lambda { where(:billing_code_id => BillingCode.find_by_name!("Fixed").id) }
  
  
  # Total hours. Add <%= @project.total_hours %> in Project view
  def total_hours
    activities.sum(:time)
  end
  
  # What type of project is this?
  def hourly?
    billing_code_id == 1
  end
  def per_diem?
    billing_code_id == 2
  end
  def fixed?
    billing_code_id == 3
  end
  
  # Budget is what user can spend
  def budget
    if billing_code_id == 3 && default_rate.present?
      self.budget = default_rate
    elsif total_unit.present? && default_rate.present?
      self.budget = total_unit.to_f * default_rate.to_f
    end
  end
  
  # Billable amount represents hours worked * rate
  def billable_amount
    if billing_code_id == 1
      self.billable_amount = total_hours.to_f * default_rate.to_f
    elsif billing_code_id == 2 && user.profile.hours_per_day.present?
      self.billable_amount = total_hours.to_f / user.profile.hours_per_day.to_f * default_rate.to_f unless user.profile.hours_per_day.nil?
    else
      self.billable_amount = default_rate.to_f
    end
  end
   
  # Clears customer and default rate for internal project
  def clears_if_internal
    if internal?
      self.default_rate = nil
      self.customer_id = nil
      self.default_rate = nil
      self.total_unit = nil
    end
  end
end