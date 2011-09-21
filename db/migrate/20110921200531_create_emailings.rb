class CreateEmailings < ActiveRecord::Migration
  def change
    create_table :emailings do |t|
      t.boolean :active, :default => true
      t.string :description, :null => false
      t.string :api_key, :null => false
      t.string :list_key

      t.timestamps
    end
    
    add_index :emailings, :api_key
  end
end
