class AddNoteAndCityToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :city, :string
    add_column :customers, :note, :text
  end

  def self.down
    remove_column :customers, :note
    remove_column :customers, :city
  end
end
