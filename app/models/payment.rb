class Payment < ActiveRecord::Base
  belongs_to :invoice

  validates_presence_of :amount
  validates_numericality_of :amount, :on => :create, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => Proc.new { |payment| payment.invoice.amount_due}
  validates_numericality_of :amount, :on => :update, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => Proc.new { |payment| payment.invoice.amount_due + payment.amount_was}
end
