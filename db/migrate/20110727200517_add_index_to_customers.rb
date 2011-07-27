class AddIndexToCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :id, :unique => true
    add_index :customers, :user_id
    change_column :customers, :name, :string, :null => false
    change_column :customers, :user_id, :integer, :null => false
  end
end
