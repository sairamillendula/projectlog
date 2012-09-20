class AddLogoToProfiles < ActiveRecord::Migration
  def change
     add_attachment :profiles, :logo
  end
end
