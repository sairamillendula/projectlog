# encoding: utf-8
class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      
      t.string :name, :size => 80
      t.string :short_name, :size => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :provinces
  end
end
