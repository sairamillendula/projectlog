class Transaction < ActiveRecord::Base
  belongs_to :project
  belongs_to :category
  
  attr_accessible :expense, :date, :amount, :tax1, :tax2, :total, :receipt, :note, :recurring, :project_id, :category_id
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

end
