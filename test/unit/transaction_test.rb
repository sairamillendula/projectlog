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
    transaction.tax1 = 10
    
    assert_equal 190, transaction.subtotal
  end
  
  test 'subtotal with tax2' do
    transaction = Transaction.new
    transaction.total = 200
    transaction.tax2 = 5
    
    assert_equal 195, transaction.subtotal
  end
  
  test 'subtotal with all taxes' do
    transaction = Transaction.new
    transaction.total = 1500
    transaction.tax1 = 10
    transaction.tax2 = 5
    
    assert_equal 1485, transaction.subtotal
  end
  
  test "should require upgrade plan if max limit reached" do
    txn = users(:two).transactions.new
    assert !txn.save
    assert_equal ["You are not allowed to create transaction. Please upgrade plan."], txn.errors[:base]
  end

end
