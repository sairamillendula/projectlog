class Profile < ActiveRecord::Base

  belongs_to :user
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :hours_per_day, 
                  :website, :user_id
  validates_numericality_of :hours_per_day, :on => :update, :allow_blank => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 10,
                            :message => "must be numeric (no comma) and between 2 and 10."
end
