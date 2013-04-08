class BarSpecials < ParseResource::Base
  fields :bar_id, :bar_location, :bar_name, :special_description, :sale_price, :expiration_date, :beer_color, :beer_size
  validates_presence_of :bar_id, :special_description, :sale_price, :beer_color
  validates :sale_price, :numericality => {greater_than: 0}
  validates :beer_color, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: 3}
  validates :beer_size, :numericality => {only_integer: true}

  before_create :ensure_fields  

  def set_expiration_date
    self.expiration_date = ParseDate.new(iso: DateTime.new(Date.tomorrow.year, Date.tomorrow.month, Date.tomorrow.day, 9).utc.iso8601)
  end

  def set_geo_location
    self.bar_location = BarEntity.find(self.bar_id).bar_location
  end

  def set_bar_name
    self.bar_name = BarEntity.find(self.bar_id).bar_name
  end

  def ensure_formats
    self.beer_color = self.beer_color.to_f
    self.sale_price = self.sale_price.to_f
    self.beer_size  = self.beer_size.to_i
  end

  def active?
    self.expiration_date > DateTime.now
  end

  def ensure_fields
    set_expiration_date
    set_bar_name
    set_geo_location
    ensure_formats
  end

  def end_special
    self.expiration_date = ParseDate.new(iso: DateTime.new(Date.yesterday.year, Date.yesterday.month, Date.yesterday.day, 9).utc.iso8601)
  end

  def reactivate_special
    self.expiration_date = ParseDate.new(iso: DateTime.new(Date.tomorrow.year, Date.tomorrow.month, Date.tomorrow.day, 9).utc.iso8601)
  end
end
