class AddLastInvoiceToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :last_invoice, :string
  end
end
