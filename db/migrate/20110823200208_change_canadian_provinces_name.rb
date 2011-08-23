# encoding: utf-8
class ChangeCanadianProvincesName < ActiveRecord::Migration
  def change
    Province.reset_column_information
    Province.find_by_name('Colombie-Britannique').update_attributes(:name => 'British Columbia')
    Province.find_by_name('Île-du-Prince-Édouard').update_attributes(:name => 'Prince Edward Island')
    Province.find_by_name('Nouveau-Brunswick').update_attributes(:name => 'New Brunswick')
    Province.find_by_name('Nouvelle-Écosse').update_attributes(:name => 'Nova Scotia')
    Province.find_by_name('Terre-Neuve-et-Labrador').update_attributes(:name => 'Newfoundland and Labrador')
    Province.find_by_name('Territoires du Nord-Ouest').update_attributes(:name => 'Northwest Territories')
  end
end
