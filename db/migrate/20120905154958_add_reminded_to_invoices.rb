class AddRemindedToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :reminded, :boolean, :default => false
  end
end
