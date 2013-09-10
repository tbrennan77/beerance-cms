class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.string :text
      t.timestamps
    end
  end
end
