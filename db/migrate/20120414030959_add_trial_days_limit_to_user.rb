class AddTrialDaysLimitToUser < ActiveRecord::Migration
  def change
    add_column :users, :trial_days_limit, :integer
  end
end