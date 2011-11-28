class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.boolean :expense, :default => true
      t.date :date
      t.float :amount
      t.float :tax1
      t.float :tax2
      t.float :total
      t.string :receipt
      t.text :note
      t.boolean :recurring, :default => false
      t.integer :user_id
      t.integer :project_id
      t.integer :category_id

      t.timestamps
    end
  end
end
