class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :user
      t.string     :category
      t.text       :comment
      t.timestamps
    end
  end
end
