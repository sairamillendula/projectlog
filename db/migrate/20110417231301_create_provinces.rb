# encoding: utf-8
class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      
      t.string :name, :size => 80
      t.string :short_name, :size => 2

      t.timestamps
    end

    Province.reset_column_information
    Province.create(:name => 'Alberta', :short_name => 'AB')
    Province.create(:name => 'Colombie-Britannique', :short_name => 'BC')
    Province.create(:name => 'Île-du-Prince-Édouard', :short_name => 'PE')
    Province.create(:name => 'Manitoba', :short_name => 'MB')
    Province.create(:name => 'Nouveau-Brunswick', :short_name => 'NB')
    Province.create(:name => 'Nouvelle-Écosse', :short_name => 'NS')
    Province.create(:name => 'Nunavut', :short_name => 'NU')
    Province.create(:name => 'Ontario', :short_name => 'ON')
    Province.create(:name => 'Québec', :short_name => 'QC')
    Province.create(:name => 'Saskatchewan', :short_name => 'SK')
    Province.create(:name => 'Terre-Neuve-et-Labrador', :short_name => 'NL')
    Province.create(:name => 'Territoires du Nord-Ouest', :short_name => 'NT')
    Province.create(:name => 'Yukon', :short_name => 'YT')
      
  end

  def self.down
    drop_table :provinces
  end
end
