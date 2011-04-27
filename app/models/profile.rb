class Profile < ActiveRecord::Base

  belongs_to :user
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :user_id

end
