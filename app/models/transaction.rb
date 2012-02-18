class Transaction < ActiveRecord::Base
  belongs_to :project
  belongs_to :category
  belongs_to :user
  
  attr_accessible :expense, :date, :amount, :tax1, :tax2, :total, :receipt, :note, :recurring, :project_id, :category_id, :category_name, :user_id
  validates_presence_of :date, :amount
  validates_numericality_of :amount
  validates_numericality_of :tax1, :tax2, :allow_blank => true
  
  scope :expenses, where(expense: true)
  scope :incomes, where(expense: false)
  scope :by_category, lambda {|category_id| where(category_id: category_id)}
  scope :by_period, lambda {|start_date, end_date| where(date: (start_date)..(end_date))}
  scope :from_date, lambda {|date| where("transactions.date >= ?", date)}
  scope :to_date, lambda {|date| where("transactions.date <= ?", date)}
  scope :by_keyword, lambda {|keyword| where('transactions.note LIKE ?', "%#{keyword}%")}
  
  def total
    amount + (try(:tax1) || 0) + (try(:tax2) || 0)
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
  
  def total_incomes
    transactions.incomes.inject(0) { |sum, p| sum + p.total }
  end
  
  def total_expenses
    transactions.expenses.inject(0) { |sum, p| sum + p.total }
  end
  #def total_incomes
  #  transactions.incomes.inject(0) { |sum, p| sum + p.total }
  #end
  
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
