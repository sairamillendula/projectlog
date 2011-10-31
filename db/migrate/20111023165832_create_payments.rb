class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :invoice, :null => false
      t.float :amount, :null => false
      t.date :date

      t.timestamps
    end
    add_index :payments, :invoice_id
  end
end
