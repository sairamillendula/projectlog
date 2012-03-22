class AddSlugToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :slug, :string

  end
end
