class AddIndexToProjects < ActiveRecord::Migration
  def change
    add_index :projects, :id
    add_index :projects, :title
    add_index :projects, :description
    add_index :projects, :default_rate
    add_index :projects, :billing_code_id
    add_index :projects, :status
    add_index :projects, :internal
    add_index :projects, :user_id
    add_index :projects, :customer_id
    change_column :projects, :user_id, :integer, :null => false
    remove_column :projects, :manager
  end
end