class AddSlugToInvoices < ActiveRecord::Migration
  def up
    add_column :invoices, :slug, :string

    Invoice.reset_column_information
    Invoice.all.each do |invoice|
      invoice.slug = Devise.friendly_token.downcase
      puts invoice.inspect
      invoice.save
    end

    change_column :invoices, :slug, :string, :null => false, :unique => true
    add_index :invoices, :slug, :unique => true
  end

  def down
    remove_column :invoices, :slug
  end
end
