class AddIndexToSettings < ActiveRecord::Migration
  def change
    add_index :settings, :var
    add_index :settings, :value
    add_index :settings, :thing_id
    add_index :settings, :thing_type
  end
end