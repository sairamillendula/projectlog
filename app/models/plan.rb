class Plan < ActiveRecord::Base
  has_many :users
  
  attr_accessible :name, :description, :features, :price, :active
  validates_presence_of :name, :price, :active
  validates_uniqueness_of :name
  
  scope :active, where(:active => true)
  scope :free, find_by_name("free")
  
  def features # Make sure features doesn't return nil
    self[:features] || ""
  end

end
