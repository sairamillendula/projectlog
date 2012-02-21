class AddFiscalYearToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :fiscal_year, :date
  end
end
