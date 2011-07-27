class AddIndexOnActivities < ActiveRecord::Migration
  def up
    add_index :activities, :id, :unique => true
    add_index :activities, :date
    add_index :activities, :project_id
    change_column :activities, :date, :date, :null => false
    change_column :activities, :time, :float, :null => false
    change_column :activities, :description, :text, :null => false
    change_column :activities, :project_id, :integer, :null => false
  end

  def down
    remove_index :activities, :id, :unique => true
    remove_index :activities, :date
    remove_index :activities, :project_id
    change_column :activities, :date, :date
    change_column :activities, :time, :float
    change_column :activities, :description, :text
    change_column :activities, :project_id, :integer
  end
end
