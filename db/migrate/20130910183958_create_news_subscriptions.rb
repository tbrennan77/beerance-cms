class CreateNewsSubscriptions < ActiveRecord::Migration
  def change
    create_table :news_subscriptions do |t|
      t.string :promoter_name
      t.string :subscriber_email
      t.string :subscriber_name
      t.string :subscriber_type
      t.timestamps
    end
  end
end
