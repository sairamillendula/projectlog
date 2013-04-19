class Project < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :customer_id, :unless => :internal?
  validates_uniqueness_of :title, :scope => :user_id
  validate :validate_limit, :on => :create
  
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  has_many :transactions
  has_many :invoices
  
  before_save :clears_if_internal
  
  attr_accessible :title, :description, :status, :default_rate, :customer_id, :billing_code_id, :internal, :total_unit, :budget,
                  :billable_amount, :unit_left, :customer_name, :user_id
  
  scope :open, where(status: true)
  scope :closed, where(status: false)
  scope :billable, where(internal: false)
  scope :unbillable, where(internal: true)
  scope :hourly, lambda { where(billing_code_id: BillingCode.find_by_name!("Hourly").id) }
  scope :per_diem, lambda { where(billing_code_id: BillingCode.find_by_name!("Per Diem").id) }
  scope :fixed, lambda { where(billing_code_id: BillingCode.find_by_name!("Fixed").id) }
  scope :of_customer, lambda {|customer_id| where(customer_id: customer_id) }
  
  
  def title_and_client
    if internal?
      "#{title} (Internal)"
    else
      "#{title} (#{customer.name})"
    end
  end
  
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
  
  
  private
  
  def validate_limit
    user = User.find(self['user_id'])
    unless user.admin?
      perm = user.plan.permissions[:project]
      if perm[:accessible]
        if perm[:limit] > 0 && user.projects.count >= perm[:limit]
          errors.add(:base, "You have reached max #{perm[:limit]} projects limit. Please upgrade plan.")
        end
      else
        errors.add(:base, "You are not allowed to create project. Please upgrade plan.")
      end
    end
  end
end