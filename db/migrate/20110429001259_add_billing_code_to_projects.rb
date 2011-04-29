class AddBillingCodeToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :billing_code_id, :integer
  end

  def self.down
    remove_column :projects, :billing_code_id
  end
end
