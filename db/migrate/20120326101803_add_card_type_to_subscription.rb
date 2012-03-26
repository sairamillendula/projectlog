class AddCardTypeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :card_type, :string
    add_column :subscriptions, :currency, :string
    add_column :subscriptions, :next_payment_date, :datetime
  end
end
