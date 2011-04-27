class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :company
      t.string :address1
      t.string :address2
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.string :phone_number
      t.string :localization
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
