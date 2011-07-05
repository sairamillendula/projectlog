class CreateLocalizations < ActiveRecord::Migration
  def self.up
    create_table :localizations do |t|
      t.string :name
      t.string :reference
      t.integer :country_id
      t.timestamps
    end
    
    Localization.create(:name => 'Argentina', :reference => 'es-AR', :country_id => '')
    Localization.create(:name => 'Australia', :reference => 'en-AU', :country_id => '')
    Localization.create(:name => 'Brazil', :reference => 'pt-BR', :country_id => '')
    Localization.create(:name => 'Canada - English', :reference => 'en-CA', :country_id => '35')
    Localization.create(:name => 'Canada - French', :reference => 'fr-CA', :country_id => '35')
    Localization.create(:name => 'China', :reference => 'zh-CN', :country_id => '')
    Localization.create(:name => 'Colombia', :reference => 'es-CO', :country_id => '')
    Localization.create(:name => 'Denmark', :reference => 'da', :country_id => '')
    Localization.create(:name => 'Estonia', :reference => 'et', :country_id => '')
    Localization.create(:name => 'France', :reference => 'fr', :country_id => '68')
    Localization.create(:name => 'Germany', :reference => 'de', :country_id => '')
    Localization.create(:name => 'India', :reference => 'hi-IN', :country_id => '')
    Localization.create(:name => 'Italy', :reference => 'it', :country_id => '')
    Localization.create(:name => 'Japan', :reference => 'ja', :country_id => '')
    Localization.create(:name => 'Korea, Republic of', :reference => 'ko', :country_id => '')
    Localization.create(:name => 'Latvia', :reference => 'lv', :country_id => '')
    Localization.create(:name => 'Mexico', :reference => 'es-MX', :country_id => '')
    Localization.create(:name => 'Netherlands', :reference => 'nl', :country_id => '')
    Localization.create(:name => 'Poland', :reference => 'pl', :country_id => '')
    Localization.create(:name => 'Portugal', :reference => 'pt-PT', :country_id => '')
    Localization.create(:name => 'Slovakia', :reference => 'sk', :country_id => '')
    Localization.create(:name => 'Swaziland', :reference => 'sw', :country_id => '')
    Localization.create(:name => 'Sweden', :reference => 'sv-SE', :country_id => '')
    Localization.create(:name => 'Switzerland - French', :reference => 'fr-CH', :country_id => '')
    Localization.create(:name => 'Switzerland - German', :reference => 'gsw-CH', :country_id => '')
    Localization.create(:name => 'Thailand', :reference => 'th', :country_id => '')
    Localization.create(:name => 'Taiwan, Province of China', :reference => 'zh-TW', :country_id => '')
    Localization.create(:name => 'United States', :reference => 'en-US', :country_id => '')
  end

  def self.down
    drop_table :localizations
  end
end