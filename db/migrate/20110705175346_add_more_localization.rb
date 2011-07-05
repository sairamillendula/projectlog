class AddMoreLocalization < ActiveRecord::Migration
  def self.up
    
    Localization.create(:name => 'Chile', :reference => 'es-CL', :country_id => '152')
    Localization.create(:name => 'Norway', :reference => 'nb', :country_id => '578')
    Localization.create(:name => 'Russia', :reference => 'ru', :country_id => '643')
    Localization.create(:name => 'Spain', :reference => 'sp', :country_id => '724')
    Localization.create(:name => 'United Kingdom', :reference => 'en-GB', :country_id => '826')
  end
  
  def self.down
    drop_table :localizations
  end
end
