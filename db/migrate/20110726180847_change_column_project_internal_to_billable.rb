class ChangeColumnProjectInternalToBillable < ActiveRecord::Migration
  def up
    rename_column :projects, :internal, :billable 
    change_column :projects, :billable, :boolean, :default => true
  end

  def down
    change_column :projects, :billable, :internal
  end
end
