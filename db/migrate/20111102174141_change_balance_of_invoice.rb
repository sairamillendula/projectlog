class ChangeBalanceOfInvoice < ActiveRecord::Migration
  def up
    change_column :invoices, :balance, :float, :default => 0, :null => false
  end

  def down
    change_column :invoices, :balance, :float, :null => false
  end
end
