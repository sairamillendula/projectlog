class AddCurrencyToLocalization < ActiveRecord::Migration
  def change
    add_column :localizations, :currency, :string, :limit => 3, :default => "USD", :null => false
    
    Localization.connection.execute("update localizations set currency='ARS' WHERE reference='es-AR'")
    Localization.connection.execute("update localizations set currency='AUD' WHERE reference='en-AU'")
    Localization.connection.execute("update localizations set currency='BRL' WHERE reference='pt-BR'")
    Localization.connection.execute("update localizations set currency='CAD' WHERE reference='en-CA'")
    Localization.connection.execute("update localizations set currency='CAD' WHERE reference='fr-CA'")
    Localization.connection.execute("update localizations set currency='CNY' WHERE reference='zh-CN'")
    Localization.connection.execute("update localizations set currency='DKK' WHERE reference='da'")
    Localization.connection.execute("update localizations set currency='EEK' WHERE reference='et'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='fr'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='de'")
    Localization.connection.execute("update localizations set currency='INR' WHERE reference='hi-IN'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='it'")
    Localization.connection.execute("update localizations set currency='JPY' WHERE reference='ja'")
    Localization.connection.execute("update localizations set currency='LVL' WHERE reference='lv'")
    Localization.connection.execute("update localizations set currency='MXN' WHERE reference='es-MX'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='nl'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='pl'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='pt-PT'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='sk'")
    Localization.connection.execute("update localizations set currency='SZL' WHERE reference='sw'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='sv-SE'")
    Localization.connection.execute("update localizations set currency='THB' WHERE reference='th'")
    Localization.connection.execute("update localizations set currency='THB' WHERE reference='zh-TW'")
    Localization.connection.execute("update localizations set currency='CLP' WHERE reference='es-CL'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='nb'")
    Localization.connection.execute("update localizations set currency='RUB' WHERE reference='ru'")
    Localization.connection.execute("update localizations set currency='EUR' WHERE reference='sp'")
    Localization.connection.execute("update localizations set currency='GBP' WHERE reference='en-GB'")
  end
end
