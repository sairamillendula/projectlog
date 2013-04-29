class AddHeaderToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :header, :text
  end
end