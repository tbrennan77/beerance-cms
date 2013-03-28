class BarSpecial < ParseUser
  fields :bar_id, :bar_location, :bar_name, :special_description, :sale_price, :expiration_prepend, :expiration_date, :beer_color, :is_regular_item
  validates_presence_of :bar_id, :special_description, :sale_price, :expiration_prepend, :expiration_date, :beer_color, :is_regular_item
end