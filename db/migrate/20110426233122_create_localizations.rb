class CreateLocalizations < ActiveRecord::Migration
  def self.up
    create_table :localizations do |t|
      t.string :name
      t.string :reference
      t.integer :country_id
      t.timestamps
    end
    
    Localization.create(:name => 'Argentina', :reference => 'es-AR', :country_id => '9')
    Localization.create(:name => 'Australia', :reference => 'en-AU', :country_id => '12')
    Localization.create(:name => 'Brazil', :reference => 'pt-BR', :country_id => '28')
    Localization.create(:name => 'Canada - English', :reference => 'en-CA', :country_id => '35')
    Localization.create(:name => 'Canada - French', :reference => 'fr-CA', :country_id => '35')
    Localization.create(:name => 'China', :reference => 'zh-CN', :country_id => '41')
    Localization.create(:name => 'Colombia', :reference => 'es-CO', :country_id => '42')
    Localization.create(:name => 'Denmark', :reference => 'da', :country_id => '53')
    Localization.create(:name => 'Estonia', :reference => 'et', :country_id => '62')
    Localization.create(:name => 'France', :reference => 'fr', :country_id => '68')
    Localization.create(:name => 'Germany', :reference => 'de', :country_id => '74')
    Localization.create(:name => 'India', :reference => 'hi-IN', :country_id => '92')
    Localization.create(:name => 'Italy', :reference => 'it', :country_id => '98')
    Localization.create(:name => 'Japan', :reference => 'ja', :country_id => '100')
    Localization.create(:name => 'Korea, Republic of', :reference => 'ko', :country_id => '106')
    Localization.create(:name => 'Latvia', :reference => 'lv', :country_id => '110')
    Localization.create(:name => 'Mexico', :reference => 'es-MX', :country_id => '130')
    Localization.create(:name => 'Netherlands', :reference => 'nl', :country_id => '142')
    Localization.create(:name => 'Poland', :reference => 'pl', :country_id => '162')
    Localization.create(:name => 'Portugal', :reference => 'pt-PT', :country_id => '163')
    Localization.create(:name => 'Slovakia', :reference => 'sk', :country_id => '183')
    Localization.create(:name => 'Swaziland', :reference => 'sw', :country_id => '193')
    Localization.create(:name => 'Sweden', :reference => 'sv-SE', :country_id => '194')
    Localization.create(:name => 'Switzerland - French', :reference => 'fr-CH', :country_id => '195')
    Localization.create(:name => 'Switzerland - German', :reference => 'gsw-CH', :country_id => '195')
    Localization.create(:name => 'Thailand', :reference => 'th', :country_id => '200')
    Localization.create(:name => 'Taiwan, Province of China', :reference => 'zh-TW', :country_id => '197')
    Localization.create(:name => 'United States', :reference => 'en-US', :country_id => '214')
  end

  def self.down
    drop_table :localizations
  end
end