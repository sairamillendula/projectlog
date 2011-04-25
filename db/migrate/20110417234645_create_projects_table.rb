class CreateProjectsTable < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      
      t.string :title
      t.string :description
      t.string :default_rate
      t.string :manager
      t.integer :project_status_id
      t.integer :user_id
      t.integer :customer_id
    
      t.timestamps
     end
  end
  
  def self.down
    drop_table :projects
  end
end
