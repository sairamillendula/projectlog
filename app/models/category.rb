class Category < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  attr_accessible :name, :user_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
end
