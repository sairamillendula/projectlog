class Transaction < ActiveRecord::Base
  include Taxable
  
  belongs_to :project
  belongs_to :category
  belongs_to :user
  
  attr_accessible :expense, :date, :total, :tax1, :tax2, :tax1_label, :tax2_label, :compound, :receipt, :note, :recurring, :project_id, :category_id, :category_name, :user_id
  validates_presence_of :date, :total, :note
  validates_numericality_of :total
  validates_numericality_of :tax1, :tax2, :allow_blank => true
  
  scope :expenses, where(expense: true)
  scope :incomes, where(expense: false)
  scope :by_category, lambda {|category_id| where(category_id: category_id)}
  scope :by_period, lambda {|start_date, end_date| where(date: (start_date)..(end_date))}
  scope :from_date, lambda {|date| where("transactions.date >= ?", date)}
  scope :to_date, lambda {|date| where("transactions.date <= ?", date)}
  scope :by_keyword, lambda {|keyword| where('transactions.note LIKE ?', "%#{keyword}%")}
  
  def subtotal
    if tax2 && compound
      (total / ((1 + ((try(:tax1) || 0) / 100.0)) * (1 + ((try(:tax2) || 0) / 100.0)))).round(2)
    else
      (total / (1 + ((try(:tax1) || 0) / 100.0) + ((try(:tax2) || 0) / 100.0))).round(2)
    end
  end
  
  def tax1_amount
    (subtotal * ((try(:tax1) || 0) / 100.0)).round(2)
  end
  
  def tax2_amount
    if tax2 && compound
      ((subtotal + tax1_amount) * ((try(:tax2) || 0) / 100.0)).round(2)
    else
      (subtotal * ((try(:tax2) || 0) / 100.0)).round(2)
    end
  end
  
  def self.search(search)
    if search
      where('"transactions"."note" LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def category_name
    category.try(:name)
  end
  
  def category_name=(name)
    current_user = user
    self.category = current_user.categories.find_or_create_by_name(name) if name.present?
  end
  
  # CLASS METHODS
  # =============
  class << self
    
    # return total incomes of given transactions
    # assumes that transactions already loaded
    def total_incomes(transactions)
      transactions.select{|t| !t.expense }.inject(0) { |sum, p| sum + p.total }
    end
    
    # return total expenses of given transactions
    # assumes that transactions already loaded
    def total_expenses(transactions)
      transactions.select{|t| t.expense }.inject(0) { |sum, p| sum + p.total }
    end
  end
  
end
