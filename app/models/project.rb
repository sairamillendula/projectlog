class Project < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :customer_id, :unless => :internal?
  validates_uniqueness_of :title, :scope => :user_id
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  has_many :transactions
  
  before_save :clears_if_internal
  
  attr_accessible :title, :description, :status, :default_rate, :customer_id, :billing_code_id, :internal, :total_unit, :budget, :billable_amount,
                  :unit_left, :customer_name
  
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
    billing_code_id == BillingCode.find_by_name!("Hourly").id
  end
  def per_diem?
    billing_code_id == BillingCode.find_by_name!("Per Diem").id
  end
  def fixed?
    billing_code_id == BillingCode.find_by_name!("Fixed").id
  end
  
  # Budget is what user can spend
  def budget
    if fixed? && default_rate.present? #budget equals default_rate because only default_rate is editable by user
      self.budget = default_rate
    else total_unit.present? && default_rate.present? #Calculate budget: default_rate * total_unit allowed
      self.budget = total_unit.to_f * default_rate.to_f
    end
  end
  
  # Billable amount = total hours worked * default_rate
  def billable_amount
    if hourly?
      self.billable_amount = total_hours.to_f * default_rate.to_f
    elsif per_diem? && user.profile.hours_per_day.present?
      self.billable_amount = total_hours.to_f / user.profile.hours_per_day.to_f * default_rate.to_f unless user.profile.hours_per_day.nil?
    else #fixed
      self.billable_amount = default_rate.to_f
    end
  end
  
  def total_expenses
    transactions.expenses.inject(0) { |sum, p| sum + p.total }
  end
  def total_incomes
    transactions.incomes.inject(0) { |sum, p| sum + p.total }
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
  
  def customer_name
    customer.try(:name)
  end
  
  def customer_name=(name)
    self.customer = self.user.customers.find_or_create_by_name(name) if name.present?
  end
end