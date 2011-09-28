class AddWebsiteToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :website, :string
    add_column :customers, :website, :string
  end
end
