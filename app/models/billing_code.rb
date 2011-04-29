class BillingCode < ActiveRecord::Base
  
  has_many :projects

  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true
  
end
