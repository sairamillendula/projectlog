class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :invoice_id
      t.string :line_type
      t.string :description, :null => false
      t.float :line_total
      t.float :tax1
      t.float :tax2
      t.float :quantity
      t.float :price
      t.float :subtotal

      t.timestamps
    end
  end
end
