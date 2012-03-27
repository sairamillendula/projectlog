class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :paypal_profile_id
      t.string :state
      t.integer :pending_subscription_id
      t.datetime :modify_on
      t.datetime :start_date
      t.boolean :active, :default => false
      t.integer :plan_id
      t.integer :user_id

      t.timestamps
    end
  end
end
