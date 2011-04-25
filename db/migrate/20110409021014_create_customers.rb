class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :postal_code
      t.string :province
      t.string :country
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
