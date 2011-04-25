class Contact < ActiveRecord::Base
  belongs_to :customer
  default_scope order('first_name', 'last_name')
  
  attr_accessible :first_name, :last_name, :title, :phone, :email, :customer_id
  
  validates_presence_of(:first_name)
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
end
