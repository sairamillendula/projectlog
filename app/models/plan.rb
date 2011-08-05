class Plan < ActiveRecord::Base
  has_many :users
  
  attr_accessible :name, :description, :features, :price, :active
  validates_presence_of :name, :price, :active
  validates_uniqueness_of :name

end
