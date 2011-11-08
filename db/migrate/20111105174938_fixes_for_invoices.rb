class FixesForInvoices < ActiveRecord::Migration
  def up
    change_column :invoices, :invoice_number, :string, :null => false
    change_column :invoices, :customer_id, :integer, :null => false
    change_column :invoices, :discount, :decimal, :precision => 5, :scale => 2, :null => false, :default => 0
    change_column :line_items, :invoice_id, :integer, :null => false
    change_column :line_items, :line_type, :string, :null => false
    change_column :line_items, :line_total, :float, :null => false, :default => 0
    change_column :line_items, :quantity, :float, :null => false, :default => 0
    change_column :line_items, :price, :float, :null => false, :default => 0
  end

  def down
    change_column :invoices, :invoice_number, :string, :null => true
    change_column :invoices, :customer_id, :integer, :null => true
    change_column :invoices, :discount, :decimal, :precision => 5, :scale => 2, :null => true
    change_column :line_items, :invoice_id, :integer, :null => true
    change_column :line_items, :line_type, :string, :null => true
    change_column :line_items, :line_total, :float, :null => true
    change_column :line_items, :quantity, :float, :null => true
    change_column :line_items, :price, :float, :null => true
  end
end
