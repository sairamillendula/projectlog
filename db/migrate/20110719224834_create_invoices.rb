class CreateInvoices < ActiveRecord::Migration
  def up
    create_table :invoices do |t|
      t.date    :issued_date, :null => false
      t.date    :due_date, :null => false
      t.string  :subject, :null => false
      t.float   :balance, :null => false
      t.integer :status, :null => false 
      t.text    :note
      t.integer :currency_id, :null => false
      t.integer :customer_id, :null => true
      t.integer :user_id, :null => false
      
      t.timestamps
    end
    
    add_index :invoices, :id, :unique => true
    add_index :invoices, :user_id
    add_index :invoices, :customer_id
  end

  def self.down
    drop_table :invoices
  end
end
