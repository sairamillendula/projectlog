class Category < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  attr_accessible :name, :user_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  
  def total_expenses
    transactions.expenses.inject(0) { |sum, p| sum + p.total }
  end
  def total_incomes
    transactions.incomes.inject(0) { |sum, p| sum + p.total }
  end
  
end
