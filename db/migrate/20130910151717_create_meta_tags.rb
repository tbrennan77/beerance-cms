class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.text :text
      t.timestamps
    end
  end
end
