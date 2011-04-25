class CreateProjectStatuses < ActiveRecord::Migration
  def self.up
    create_table :project_statuses do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    
    ProjectStatus.reset_column_information
    ProjectStatus.create(:name => 'Open', :position => '1')
    ProjectStatus.create(:name => 'Closed', :position => '2')
  end

  def self.down
    drop_table :project_statuses
  end
end
