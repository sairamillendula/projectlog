class AddStatesToProvinces < ActiveRecord::Migration
  def change
    Province.reset_column_information
    Province.create(:name => 'Alabama', :short_name => 'AL')
    Province.create(:name => 'Alaska', :short_name => 'AK')
    Province.create(:name => 'Arizona', :short_name => 'AZ')
    Province.create(:name => 'Arkansas', :short_name => 'AR')
    Province.create(:name => 'California', :short_name => 'CA')
    Province.create(:name => 'Colorado', :short_name => 'CO')
    Province.create(:name => 'Connecticut', :short_name => 'CT')
    Province.create(:name => 'Delaware', :short_name => 'DE')
    Province.create(:name => 'District of Columbia', :short_name => 'DC')
    Province.create(:name => 'Florida', :short_name => 'FL')
    Province.create(:name => 'Georgia', :short_name => 'GA')
    Province.create(:name => 'Hawaii', :short_name => 'HI')
    Province.create(:name => 'Idaho', :short_name => 'ID')
    Province.create(:name => 'Illinois', :short_name => 'IL')
    Province.create(:name => 'Indiana', :short_name => 'IN')
    Province.create(:name => 'Iowa', :short_name => 'IA')
    Province.create(:name => 'Kansas', :short_name => 'KS')
    Province.create(:name => 'Kentucky', :short_name => 'KY')
    Province.create(:name => 'Louisiana', :short_name => 'LA')
    Province.create(:name => 'Maine', :short_name => 'ME')
    Province.create(:name => 'Maryland', :short_name => 'MD')
    Province.create(:name => 'Massachusetts', :short_name => 'MA')
    Province.create(:name => 'Michigan', :short_name => 'MI')
    Province.create(:name => 'Minnesota', :short_name => 'MN')
    Province.create(:name => 'Mississippi', :short_name => 'MS')
    Province.create(:name => 'Missouri', :short_name => 'MO')
    Province.create(:name => 'Montana', :short_name => 'MT')
    Province.create(:name => 'Nebraska', :short_name => 'NE')
    Province.create(:name => 'Nevada', :short_name => 'NV')
    Province.create(:name => 'New Hampshire', :short_name => 'NH')
    Province.create(:name => 'New Jersey', :short_name => 'NJ')
    Province.create(:name => 'New Mexico', :short_name => 'NM')
    Province.create(:name => 'New York', :short_name => 'NY')
    Province.create(:name => 'North Carolina', :short_name => 'NC')
    Province.create(:name => 'North Dakota', :short_name => 'ND')
    Province.create(:name => 'Ohio', :short_name => 'OH')
    Province.create(:name => 'Oklahoma', :short_name => 'OK')
    Province.create(:name => 'Oregon', :short_name => 'OR')
    Province.create(:name => 'Pennsylvania', :short_name => 'PA')
    Province.create(:name => 'Rhode Island', :short_name => 'RI')
    Province.create(:name => 'South Carolina', :short_name => 'SC')
    Province.create(:name => 'South Dakota', :short_name => 'SD')
    Province.create(:name => 'Tennessee', :short_name => 'TN')
    Province.create(:name => 'Texas', :short_name => 'TX')
    Province.create(:name => 'Utah', :short_name => 'UT')
    Province.create(:name => 'Vermont', :short_name => 'VT')
    Province.create(:name => 'Virginia', :short_name => 'VA')
    Province.create(:name => 'Washington', :short_name => 'WA')
    Province.create(:name => 'West Virginia', :short_name => 'WV')
    Province.create(:name => 'Wisconsin', :short_name => 'WI')
    Province.create(:name => 'Wyoming', :short_name => 'WY')
  end
end