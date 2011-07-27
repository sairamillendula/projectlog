class AddIndexToCountries < ActiveRecord::Migration
  def change
    add_index :countries, :id, :unique => true
    add_index :countries, :name
    add_index :countries, :printable_name
    change_column :countries, :name, :string, :null => false
    change_column :countries, :printable_name, :string, :null => false
  end
end
