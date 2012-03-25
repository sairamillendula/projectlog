class SubscriptionTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription
  
  def self.search(search)
    if search
      where('`subscription_transactions`.code LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
end
