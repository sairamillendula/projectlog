class Profile < ActiveRecord::Base
  include Taxable
  
  belongs_to :user
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :hours_per_day,
                  :website, :user_id, :user_id, :tax1, :tax2, :tax1_label, :tax2_label, :invoice_signature, :compound

  validates_numericality_of :hours_per_day, :on => :update, :allow_blank => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 10,
                            :message => "must be numeric (no comma) and between 2 and 10."

end
