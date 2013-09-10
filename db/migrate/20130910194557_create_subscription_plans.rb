class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.integer :amount
      t.string  :friendly_name
      t.string  :image
      t.integer :length_in_months
      t.string  :name
      t.timestamps
    end
  end
end
