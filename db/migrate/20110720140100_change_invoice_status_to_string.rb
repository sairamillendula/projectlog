class ChangeInvoiceStatusToString < ActiveRecord::Migration
  def up
    change_column :invoices, :status, :string
  end

  def down
    change_column :invoices, :status, :integer
  end
end
