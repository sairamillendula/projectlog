class Profile < ActiveRecord::Base

  belongs_to :user
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :hours_per_day,
                  :website, :user_id, :user_id, :tax1, :tax2, :tax1_label, :tax2_label, :invoice_signature

  validates_numericality_of :hours_per_day, :on => :update, :allow_blank => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 10,
                            :message => "must be numeric (no comma) and between 2 and 10."

  def any_taxes?
    !(tax1.blank? && tax2.blank?)
  end

  def tax1_name
    if tax1_label.blank? then
      "Tax 1 (#{tax1} %)"
    else
      "#{tax1_label} (#{tax1} %)"
    end
  end

  def tax2_name
    if tax2_label.blank? then
      "Tax 2 (#{tax2} %)"
    else
      "#{tax2_label} (#{tax2} %)"
    end
  end

  def tax_options
    taxes = [["no tax", 0]]
    taxes << [tax1_name, 1] unless tax1.blank?
    taxes << [tax2_name, 2] unless tax2.blank?
    taxes << ["both", 3] unless tax1.blank? || tax2.blank?
    taxes
  end
end
