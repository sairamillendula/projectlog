class AddTaxesToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :tax1, :float
    add_column :invoices, :tax1_label, :string
    add_column :invoices, :tax2, :float
    add_column :invoices, :tax2_label, :string
    add_column :invoices, :compound, :boolean
    
    remove_column :line_items, :subtotal
    add_column :line_items, :position, :integer
  end
end
