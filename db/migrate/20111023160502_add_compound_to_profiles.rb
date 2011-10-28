class AddCompoundToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :compound, :boolean, :null => false, :default => false, :after => "tax2"
  end
end
