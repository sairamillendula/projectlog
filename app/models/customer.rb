class Customer < ActiveRecord::Base
  
  belongs_to :user
  has_many :contacts, :dependent => :destroy
  has_many :projects, :dependent => :restrict
  has_many :invoices, :dependent => :restrict
  
  attr_accessible :name, :phone, :address1, :address2, :postal_code, :city, :province, :country, :note
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :scope => :user_id
  default_scope order('name')
  
end
