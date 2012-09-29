class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      
      t.string :name, :null => false
      t.text :description
      t.text :features
      t.float :price, :null => false
      t.boolean :active, :default => false
      
      t.timestamps
    end
    
    add_index :plans, :id
    add_index :plans, :name
    add_index :plans, :price
  end
end