module TransactionsHelper
  def total_incomes
    @total_incomes = Transaction.incomes.sum.inject(0) { |sum, p| sum + p.total }
  end  
    
end