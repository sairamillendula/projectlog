class Transaction < ActiveRecord::Base
  include Taxable
  
  belongs_to :project
  belongs_to :category
  belongs_to :user
  
  attr_accessible :expense, :date, :total, :tax1, :tax2, :tax1_label, :tax2_label, :tax1_amount, :tax2_amount, :compound, :receipt, :note,
                  :recurring, :project_id, :category_id, :category_name, :user_id
  validates_presence_of :date, :total, :note
  validates_numericality_of :total
  validates_numericality_of :tax1, :tax2, :allow_blank => true
  validate :validate_limit, :on => :create
  
  scope :expenses, where(expense: true)
  scope :incomes, where(expense: false)
  scope :by_category, lambda {|category_id| where(category_id: category_id)}
  scope :from_date, lambda {|date| where("transactions.date >= ?", date)}
  scope :to_date, lambda {|date| where("transactions.date <= ?", date)}
  scope :by_keyword, lambda {|keyword| where('(transactions.note LIKE ?) OR (transactions.total = ?)', "%#{keyword}%", keyword)}
  scope :by_period, lambda {|date_range| where(:date => date_range)}
  
  def subtotal
    (total - (try(:tax1) || 0) - (try(:tax2) || 0)).round(2)
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
    if name.blank?
      self.category = nil
    else
      current_user = user
      self.category = current_user.categories.find_or_create_by_name(name)
    end
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
    
    def fiscal_periods(from, to)
      
      if fiscal_year.blank?
        from = Date.new(this_year - 1, 1, 1)
        to = Date.new(this_year, 1, 1)
        (from..to)
      else
        from = Date.new(this_year - 1, fiscal_year.month, fiscal_year.day)
        to = Date.new(this_year, fiscal_year.month, fiscal_year.day)
        (from..to)
      end
    end
  end
  
  private
  
  def validate_limit
    user = User.find(self['user_id'])
    unless user.admin?
      perm = user.plan.permissions[:transaction]
      if perm[:accessible]
        if perm[:limit] > 0 && user.transactions.count >= perm[:limit]
          errors.add(:base, "You have reached max #{perm[:limit]} transactions limit. Please upgrade plan.")
        end
      else
        errors.add(:base, "You are not allowed to create transaction. Please upgrade plan.")
      end
    end
  end
  
end
