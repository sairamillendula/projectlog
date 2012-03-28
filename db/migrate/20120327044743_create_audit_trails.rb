class CreateAuditTrails < ActiveRecord::Migration
  def change
    create_table :audit_trails do |t|
      t.integer :user_id
      t.string :action
      t.text :message

      t.timestamps
    end
  end
end
