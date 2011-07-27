class AddIndexToProvinces < ActiveRecord::Migration
  def change
    add_index :provinces, :name
  end
end
