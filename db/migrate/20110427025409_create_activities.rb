class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.date :date
      t.float :time
      t.text :description
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
