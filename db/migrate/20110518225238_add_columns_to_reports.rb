class AddColumnsToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :user_id, :integer
    add_column :reports, :project_id, :integer
    add_column :reports, :start_date, :date
    add_column :reports, :end_date, :date
    add_column :reports, :slug, :string
  end

  def self.down
    remove_column :reports, :slug
    remove_column :reports, :end_date
    remove_column :reports, :start_date
    remove_column :reports, :project_id
    remove_column :reports, :user_id
  end
end
