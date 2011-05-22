class RemoveColumnProjectStatusId < ActiveRecord::Migration
  def self.up
    remove_column :projects, :project_status_id
    add_column :projects, :status, :boolean, :default => true
  end

  def self.down
    add_column :projects, :project_status_id
    remove_column :projects, :status
  end
end
