class AddIndexToContacts < ActiveRecord::Migration
  def change
    add_index :contacts, :id, :unique => true
    add_index :contacts, :customer_id
    change_column :contacts, :customer_id, :integer, :null => false
    change_column :contacts, :first_name, :string, :null => false
  end
end
