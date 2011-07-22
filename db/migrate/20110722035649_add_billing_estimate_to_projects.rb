class AddBillingEstimateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :billing_estimate, :string
  end
end
