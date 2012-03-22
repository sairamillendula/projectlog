class AddFrequencyToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :frequency, :string
    add_column :plans, :displayable, :boolean
  end
end
