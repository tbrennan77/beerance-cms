class BarSpecial < ParseUser
  fields :bar_id, :bar_location, :bar_name, :special_description, :sale_price, :expiration_date, :beer_color
  validates_presence_of :bar_id, :special_description, :sale_price, :expiration_date, :beer_color

  before_save :ensure_fields

  def set_expiration_date
    self.expiration_date = ParseDate.new(iso: Time.parse(self.expiration_date).utc.iso8601)
  end

  def set_geo_location
    self.bar_location = ParseGeoPoint.new :latitude => 34.09300844216167, :longitude => -118.3780094460731
  end

  def set_bar_name
    self.bar_name = BarEntity.find(self.bar_id).bar_name
  end

  def ensure_formats
    self.beer_color = self.beer_color.to_f
    self.sale_price = self.sale_price.to_f
  end

  def ensure_fields
    set_expiration_date
    set_bar_name
    set_geo_location
    ensure_formats
  end
end