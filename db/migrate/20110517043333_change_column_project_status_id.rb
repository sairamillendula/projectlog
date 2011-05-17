class ChangeColumnProjectStatusId < ActiveRecord::Migration
  def self.up
   change_column :projects, :project_status_id, :integer, :default => '1'
  end

  def self.down
    change_column :projects, :project_status_id
  end
end
