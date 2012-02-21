class RemoveAmountFromTransaction < ActiveRecord::Migration
  def up
    remove_column :transactions, :total
    rename_column :transactions, :amount, :total
    add_column :transactions, :tax1_label, :string
    add_column :transactions, :tax2_label, :string
    add_column :transactions, :compound, :boolean
  end

  def down
    add_column :transactions, :total, :float
    rename_column :transactions, :total, :amount
    remove_column :transactions, :tax1_label
    remove_column :transactions, :tax2_label
    remove_column :transactions, :compound
  end
end