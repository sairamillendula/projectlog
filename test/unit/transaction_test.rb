require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  
  test 'total expenses' do
    assert true
  end
  
  test 'total incomes' do
    assert true
  end
  
  test 'subtotal without taxes' do
    transaction = Transaction.new
    transaction.total = 200
    assert_equal 200, transaction.subtotal
  end
  
  test 'subtotal with tax1' do
    transaction = Transaction.new
    transaction.total = 200
    transaction.tax1 = 10 # 10%
    
    assert_equal 181.82, transaction.subtotal
    assert_equal 200, transaction.subtotal + transaction.tax1_amount
  end
  
  test 'subtotal with tax2' do
    transaction = Transaction.new
    transaction.total = 200
    transaction.tax2 = 5 # 5%
    
    assert_equal 190.48, transaction.subtotal
    assert_equal 200, transaction.subtotal + transaction.tax2_amount
  end
  
  test 'subtotal with tax2 and compound' do
    transaction = Transaction.new
    transaction.total = 200
    transaction.tax2 = 5 # 5%
    transaction.compound = true
    
    assert_equal 190.48, transaction.subtotal
    assert_equal 200, transaction.subtotal + transaction.tax2_amount
  end
  
  test 'subtotal with all taxes' do
    transaction = Transaction.new
    transaction.total = 1500
    transaction.tax1 = 10 # 10%
    transaction.tax2 = 5 # 5%
    
    assert_equal 173.91, transaction.subtotal
    assert_equal 200, transaction.subtotal + transaction.tax1_amount + transaction.tax2_amount
  end
  
  test 'subtotal with all taxes and compound' do
    transaction = Transaction.new
    transaction.total = 200
    transaction.tax1 = 10 # 10%
    transaction.tax2 = 5 # 5%
    transaction.compound = true
    
    assert_equal 173.16, transaction.subtotal
    assert_equal 200, transaction.subtotal + transaction.tax1_amount + transaction.tax2_amount
  end

end
