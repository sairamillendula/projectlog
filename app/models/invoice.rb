class Invoice < ActiveRecord::Base
  include Taxable
  
  belongs_to :user
  belongs_to :customer
  has_many :line_items, :dependent => :destroy, :order => 'position'
  has_many :payments, :dependent => :destroy

  before_create :generate_invoice_number_and_slug
  before_save :update_balance

  scope :current_year, where('year(issued_date) = ?', Date.today.year)
  scope :with_balance, where("balance > ?", 0)
  scope :overdue, where("due_date < ?", Date.today)

  validates :subject, :status, :customer, :due_date, :issued_date, :currency, :presence => true
  validate :validate_limit, :on => :create

  accepts_nested_attributes_for :line_items, :allow_destroy => :true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessible :invoice_number, :issued_date, :due_date, :subject, :balance, :status, :note, :currency, :customer_id, :discount,
                  :line_items_attributes, :tax1, :tax1_label, :tax2, :tax2_label, :compound, :user_id

  def to_param
    slug
  end
  
  def tax1_amount
    (subtotal * ((try(:tax1) || 0) / 100)).round(2)
  end
  
  def tax2_amount
    if tax2 and compound
      ((subtotal + tax1_amount) * ((try(:tax2) || 0) / 100)).round(2)
    else
      (subtotal * ((try(:tax2) || 0) / 100)).round(2)
    end
  end
  
  def discount_amount
    (subtotal * discount / 100.0).round(2)
  end
  
  def subtotal
    line_items.collect(&:subtotal).sum.round(2)
  end

  def amount_due
    (subtotal + tax1_amount + tax2_amount - discount_amount).round(2)
  end

  def balance_calc
    (amount_due - payments.collect(&:amount).sum.round(2)).round(2)
  end

  def self.status_list
    ['Draft', 'Sent', 'Partial Payment', 'Paid']
  end

  def paid?
    status == "Paid"
  end
  
  def is_fully_paid?
    balance_calc == 0
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
  
  def prepare_new_invoice
    profile = user.profile
    self.currency ||= profile.localization && Localization.find_by_reference(profile.localization) && Localization.find_by_reference(profile.localization).currency || "USD"
    self.discount ||= 0
    self.line_items.build(:quantity => 1, :price => 0.0)
    self.note ||= profile.invoice_signature
    self.tax1 = profile.tax1
    self.tax1_label = profile.tax1_label
    self.tax2 = profile.tax2
    self.tax2_label = profile.tax2_label
    self.compound = profile.compound
  end
  
private
  
  def validate_limit
    user = User.find(self['user_id'])
    unless user.admin?
      perm = user.plan.permissions[:invoice]
      if perm[:accessible]
        if perm[:limit] > 0 && user.invoices.count >= perm[:limit]
          errors.add(:base, "You have reached max #{perm[:limit]} invoices limit. Please upgrade plan.")
        end
      else
        errors.add(:base, "You are not allowed to create invoices. Please upgrade plan.")
      end
    end
  end
end