class Project < ActiveRecord::Base
  
  validates_presence_of :title, :customer_id
  belongs_to :user
  belongs_to :customer
  belongs_to :project_status
  has_many :activities, :dependent => :destroy
  
  attr_accessible :title, :description, :project_status_id, :default_rate, :manager, :customer_id
  
  default_scope :order => 'project_status_id DESC'
  
  STATUS = [ 'Open', 'Closed' ]

end
