class CreateSubscriptionTransactions < ActiveRecord::Migration
  def change
    create_table :subscription_transactions do |t|
      t.string :code
      t.float :amount
      t.integer :subscription_id
      t.integer :user_id

      t.timestamps
    end
  end
end
