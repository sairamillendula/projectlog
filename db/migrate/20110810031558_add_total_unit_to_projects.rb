class AddTotalUnitToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :total_unit, :float
    add_column :projects, :unit_left, :float
    add_column :projects, :billable_amount, :float
    add_column :projects, :budget, :float
    add_index :projects, :total_unit
    add_index :projects, :unit_left
    add_index :projects, :billable_amount
    add_index :projects, :budget
    remove_column :projects, :billing_estimate
  end
end
