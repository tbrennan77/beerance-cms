class CreateBarSpecials < ActiveRecord::Migration
  def change
    create_table :bar_specials do |t|
      t.references :bar
      t.integer    :beer_color
      t.integer    :beer_size
      t.datetime   :expiration_date
      t.integer    :sale_price
      t.string     :description
      t.string     :parse_bar_special_id
      t.timestamps
    end
  end
end
