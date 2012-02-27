class Profile < ActiveRecord::Base
  include Taxable
  
  belongs_to :user
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :hours_per_day,
                  :website, :user_id, :user_id, :tax1, :tax2, :tax1_label, :tax2_label, :invoice_signature, :compound, :fiscal_year

  validates_numericality_of :hours_per_day, :on => :update, :allow_blank => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 10,
                            :message => "must be numeric (no comma) and between 2 and 10."

  def fiscal_period(this_year=Time.now.year)
    if fiscal_year.blank?
      from = Date.new(this_year, 1, 1)
      to = Date.new(this_year + 1, 1, 1)
      (from..to)
    else
      from = Date.new(this_year, fiscal_year.month, fiscal_year.day)
      to = Date.new(this_year + 1, fiscal_year.month, fiscal_year.day)
      (from..to)
    end
  end
  
  def fiscal_range
    range = []
    first_transaction = user.transactions.order("date").first
    first_year = first_transaction.date.year
    current_year = Date.today.year
    
    if fiscal_year.blank?
      range = (first_year..current_year).to_a.map{|year| Profile.period_to_s(Date.new(year, 1, 1), Date.new(year + 1, 1, 1)) }
    else
      if first_transaction.date < Date.new(first_year, fiscal_year.month, fiscal_year.day)
        range = ((first_year - 1)..current_year).to_a.map{|year| Profile.period_to_s(Date.new(year, fiscal_year.month, fiscal_year.day), Date.new(year + 1, fiscal_year.month, fiscal_year.day)) }
      else
        range = (first_year..current_year).to_a.map{|year| Profile.period_to_s(Date.new(year, fiscal_year.month, fiscal_year.day), Date.new(year + 1, fiscal_year.month, fiscal_year.day)) }
      end        
    end
    range
  end
  
  class << self
    def period_to_s(from, to)
      "#{from.strftime("%m/%d/%Y")} - #{to.strftime("%m/%d/%Y")}"
    end
    
    def to_period(str)
      arr = str.scan(/\d{2}\/\d{2}\/\d{4}/)
      return nil if arr.length != 2
      from,to = arr
      (Date.strptime(from, '%m/%d/%Y')..Date.strptime(to, '%m/%d/%Y'))
    end
  end
end
