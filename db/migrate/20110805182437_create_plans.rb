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
    Plan.create(:name => "Free", :description => "Basic Plan free for everyone who sign up", :price => "0", :active => true )
  end
end
