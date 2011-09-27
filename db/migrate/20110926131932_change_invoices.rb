class ChangeInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_number, :string
    add_column :invoices, :discount, :decimal, :precision => 5, :scale => 2
    remove_column :invoices, :currency_id
    add_column :invoices, :currency, :string, :limit => 3, :null => false

    add_index :invoices, :invoice_number
  end
end
