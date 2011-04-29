class RenameBillingCodeLabelToBillingCodeName < ActiveRecord::Migration
  def self.up
    rename_column :billing_codes, :label, :name
  end

  def self.down
    rename_column :billing_codes, :name, :label
  end
end
