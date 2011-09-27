class ChangeProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :tax1_label, :string
    add_column :profiles, :tax1, :float
    add_column :profiles, :tax2_label, :string
    add_column :profiles, :tax2, :float
    add_column :profiles, :invoice_signature, :text
  end
end
