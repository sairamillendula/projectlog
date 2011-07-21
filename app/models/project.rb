class Project < ActiveRecord::Base
  
  validates_presence_of :title, :customer_id
  validates_uniqueness_of :title, :scope => :user_id
  belongs_to :user
  belongs_to :customer
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  
  attr_accessible :title, :description, :status, :default_rate, :manager, :customer_id, :billing_code_id, :internal
  
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
  
end
