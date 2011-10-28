class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  has_many :line_items
  has_many :payments

  scope :current_year, where('year(issued_date) = ?', Date.today.year)

  validates :subject, :balance, :customer, :presence => true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessible :invoice_number, :issued_date, :due_date, :subject, :balance, :status, :note, :currency, :customer_id, :discount, :line_items_attributes

  def amount_due
    total = line_items.sum(:line_total)
    ((total - total*discount/100).round(2) - (payments.sum(:amount)).round(2)).round(2)
  end

  def self.status_list
    ['draft', 'sent', 'partial payment', 'paid']
  end

  def paid?
     status == "paid"
  end

  def generate_invoice_number
    i = 0
    begin
      i += 1
      num = "(#{Date.today.year})-#{"%03d" % (user.invoices.current_year.size + i)}"
    end while user.invoices.find_by_invoice_number(num)
    num
  end
end
