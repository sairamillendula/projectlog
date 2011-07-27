class AddIndexToReports < ActiveRecord::Migration
  def change
    add_index :reports, :id
    add_index :reports, :slug
    add_index :reports, :user_id
    add_index :reports, :project_id
    change_column :reports, :slug, :string, :null => false, :unique => true
  end
end