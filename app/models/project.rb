class Project < ActiveRecord::Base
  
  validates_presence_of :title, :customer_id, :project_status_id
  belongs_to :user
  belongs_to :customer
  belongs_to :project_status
  belongs_to :billing_code
  has_many :activities, :dependent => :destroy
  
  attr_accessible :title, :description, :project_status_id, :default_rate, :manager, :customer_id, :billing_code_id
  
  default_scope :order => 'project_status_id DESC'
  scope :open, where("projects.project_status_id = '1' ")
  scope :closed, where("projects.project_status_id = '2' ")
  
  STATUS = [ 'Open', 'Closed' ]
  
  # Total hours. Add <%= @project.total_hours %> in Project view
  def total_hours
    activities.sum(:time)
  end

end
