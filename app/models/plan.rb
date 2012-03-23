class Plan < ActiveRecord::Base
  has_many :users, :dependent => :restrict
  
  attr_accessible :name, :description, :features, :price, :active, :displayable
  validates_presence_of :name, :price, :description
  validates_uniqueness_of :name
  
  scope :active, where(:active => true)
  scope :displayable, where(:displayable => true)
  scope :free, find_by_name("free")
  
  def features # Make sure features doesn't return nil
    self[:features] || ""
  end
  
  def can_be_destroyed?
    users.count == 0
  end
  
  def max_plan?
    max_plan = Plan.active.order('price DESC').first
    self == max_plan
  end

end
