class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.references :user
      t.references :subscription_plan
      t.string     :stripe_customer_id    
      t.string     :name
      t.string     :address
      t.string     :address_2
      t.string     :city
      t.string     :state
      t.string     :zip
      t.string     :phone
      t.string     :url
      t.float      :latitude
      t.float      :longitude
      t.string     :sunday_start
      t.string     :sunday_end
      t.string     :monday_start
      t.string     :monday_end
      t.string     :tuesday_start
      t.string     :tuesday_end
      t.string     :wednesday_start
      t.string     :wednesday_end
      t.string     :thursday_start
      t.string     :thursday_end
      t.string     :friday_start
      t.string     :friday_end
      t.string     :saturday_start
      t.string     :saturday_end
      t.timestamps
    end
  end
end
