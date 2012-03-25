class SubscriptionTransactionObserver < ActiveRecord::Observer
  
  def after_create(transaction)
    SubscriptionTransactionMailer.payment_receipt_email(transaction).deliver
  end
end


