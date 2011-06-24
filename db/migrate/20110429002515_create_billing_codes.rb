class CreateBillingCodes < ActiveRecord::Migration
  def self.up
    create_table :billing_codes do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
    
    BillingCode.reset_column_information
    BillingCode.create(:name => 'Hourly')
    BillingCode.create(:name => 'Per Diem')
    BillingCode.create(:name => 'Fixed')
  end

  def self.down
    drop_table :billing_codes
  end
end