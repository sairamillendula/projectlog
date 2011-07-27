class AddIndexToLocalizations < ActiveRecord::Migration
  def change
    add_index :localizations, :id, :unique => true
    add_index :localizations, :name
    add_index :localizations, :country_id
    change_column :localizations, :name, :string, :null => false
  end
end
