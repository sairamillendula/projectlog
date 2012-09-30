class Profile < ActiveRecord::Base
  include Taxable

  IMAGE_TYPES = %w{image/png application/png image/jpeg application/jpeg image/jpg application/jpg image/gif application/gif}

  belongs_to :user

  has_attached_file :logo, 
                    :url => "/uploads/logo/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/logo/:id/:style/:basename.:extension",
                    :size => { :in => 0..2.megabytes }, 
                    :styles => { :thumb => "200x100>" }

  attr_accessor :remove_logo
  attr_accessible :company, :address1, :address2, :city, :province, :postal_code, :country, :phone_number, :localization, :hours_per_day,
                  :website, :user_id, :user_id, :tax1, :tax2, :tax1_label, :tax2_label, :invoice_signature, :compound, :fiscal_year, :logo, :remove_logo



  validates_numericality_of :hours_per_day, :on => :update, :allow_blank => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 10,
                            :message => "must be numeric (no comma) and between 2 and 10."

  validates_attachment_content_type :logo, :content_type => IMAGE_TYPES, :message => 'must be an image (jpeg, png or gif)'
  validates_attachment_size :logo, :less_than => 2.megabytes, :message => "File size cannot exceed 2MB"

  before_post_process :process_image_only

  def remove_logo=(val)
    logo.clear if val == '1'
  end

  def process_image_only
    set_content_type
    image?
  end

  def image?
    IMAGE_TYPES.include?(logo_content_type)
  end
  
  def set_content_type
    self.logo_content_type = MIME::Types.type_for(self.logo_file_name).first.to_s
  end

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
