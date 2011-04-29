class CreateBillingCodes < ActiveRecord::Migration
  def self.up
    create_table :billing_codes do |t|
      t.integer :id
      t.string :label

      t.timestamps
    end
    
    BillingCode.reset_column_information
    BillingCode.create(:label => 'Hourly')
    BillingCode.create(:label => 'Per Diem')
    BillingCode.create(:label => 'Fixed')
  end

  def self.down
    drop_table :billing_codes
  end
end
