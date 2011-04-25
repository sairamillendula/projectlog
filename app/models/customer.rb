class Customer < ActiveRecord::Base
  
  belongs_to :user
  has_many :contacts, :dependent => :destroy
  has_many :projects
  
  attr_accessible :name, :phone, :address1, :address2, :postal_code, :city, :province, :country, :note, :user_id
  
  validates :name, :presence => true, :uniqueness => true
  default_scope order('name')
  
end
