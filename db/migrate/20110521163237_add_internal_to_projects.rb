class AddInternalToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :internal, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :internal
  end
end
