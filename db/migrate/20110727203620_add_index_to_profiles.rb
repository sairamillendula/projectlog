class AddIndexToProfiles < ActiveRecord::Migration
  def change
    add_index :profiles, :id, :unique => true
    add_index :profiles, :company
    add_index :profiles, :address1
    add_index :profiles, :address2
    add_index :profiles, :city
    add_index :profiles, :province
    add_index :profiles, :postal_code
    add_index :profiles, :country
    add_index :profiles, :phone_number
    add_index :profiles, :localization
    add_index :profiles, :hours_per_day
    add_index :profiles, :user_id
    change_column :profiles, :user_id, :integer, :null => false
  end
end