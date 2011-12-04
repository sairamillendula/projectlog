class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  has_many :line_items, :dependent => :destroy
  has_many :payments, :dependent => :destroy

  before_create :generate_invoice_number_and_slug
  before_save :update_balance

  scope :current_year, where('year(issued_date) = ?', Date.today.year)

  validates :subject, :status, :customer, :due_date, :issued_date, :currency, :presence => true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessible :invoice_number, :issued_date, :due_date, :subject, :balance, :status, :note, :currency, :customer_id, :discount,
                  :line_items_attributes

  def to_param
    slug
  end

  def amount_due
    total = line_items.collect(&:line_total).sum
    ((total - total*discount/100).round(2)).round(2)
  end

  def balance_calc
    (amount_due - payments.collect(&:amount).sum).round(2)
  end

  def self.status_list
    ['Draft', 'Sent', 'Partial Payment', 'Paid']
  end

  def paid?
    status == "Paid"
  end

  def generate_invoice_number_and_slug
    p = user.profile
    if p.last_invoice && p.last_invoice[1..4] == Date.today.year.to_s
      pre, num = p.last_invoice.split '-'
      p.last_invoice = "#{pre}-#{"%03d" % (num.to_i + 1)}"
    else
      p.last_invoice = "(#{Date.today.year})-001"
    end
    p.save
    self.invoice_number = p.last_invoice
    self.slug = Devise.friendly_token.downcase
  end

  def update_balance
    self.balance = self.balance_calc
  end
end