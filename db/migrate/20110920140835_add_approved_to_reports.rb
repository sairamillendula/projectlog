class AddApprovedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :approved, :boolean, :default => false
    add_column :reports, :approved_at, :date
    add_column :reports, :approved_ip, :string
  end
end
