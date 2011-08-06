class AddIndexToPlanIdToUsers < ActiveRecord::Migration
  def change
    add_index :users, :plan_id
  end
end
