class ChangeQuantityInLineItems < ActiveRecord::Migration
  def up
    change_column :line_items, :quantity, :float, :null => false, :default => 1
  end

  def down
    change_column :line_items, :quantity, :float, :null => false, :default => 0
  end
end
