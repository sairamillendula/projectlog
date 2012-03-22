class SubscriptionTransactionObserver < ActiveRecord::Observer
  
  def after_create(transaction)
    # TODO: send invoice email
  end
end


