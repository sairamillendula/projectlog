class Transaction < ActiveRecord::Base
  belongs_to :project
  belongs_to :category
  belongs_to :user
  
  attr_accessible :expense, :date, :amount, :tax1, :tax2, :total, :receipt, :note, :recurring, :project_id, :category_id, :category_name
  validates_presence_of :date, :amount
  validates_numericality_of :amount, :tax1, :tax2
  
  scope :expenses, where(expense: true)
  scope :incomes, where(expense: false)
  
  def expense
    expense = true
  end
  
  def total
    amount + tax1 + tax2
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
    @total_incomes = 'Bla'
  end
  
  def total_expenses
    transactions.expenses.inject(0) { |sum, p| sum + p.total }
  end
  #def total_incomes
  #  transactions.incomes.inject(0) { |sum, p| sum + p.total }
  #end
  
end
