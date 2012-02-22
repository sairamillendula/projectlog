class RemoveTaxesFromLineItem < ActiveRecord::Migration
  def up
    remove_column :line_items, :tax1
    remove_column :line_items, :tax2
    remove_column :line_items, :line_total
  end

  def down
    add_column :line_items, :tax1, :float
    add_column :line_items, :tax2, :float
    add_column :line_items, :line_total, :float
  end
end
