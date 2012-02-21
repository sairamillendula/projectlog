class RemoveTaxRateFromTransaction < ActiveRecord::Migration
  def up
    remove_column :transactions, :tax1_label
    remove_column :transactions, :tax2_label
    remove_column :transactions, :compound
  end

  def down
    add_column :transactions, :tax1_label, :string
    add_column :transactions, :tax2_label, :string
    add_column :transactions, :compound, :boolean
  end
end
