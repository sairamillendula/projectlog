class LineItem < ActiveRecord::Base
  belongs_to :invoice

  validates_presence_of :description
  validates_presence_of :quantity
  validates_presence_of :price
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  
  # subtotal excludes taxes
  def subtotal
    quantity * price
  end
end
