class AddCardDeclinedToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :card_declined, :boolean, :default => false

  end
end
