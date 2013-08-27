class BarSpecials < ParseResource::Base
  fields :bar_id,
    :bar_location,
    :bar_name,
    :special_description,
    :sale_price,
    :expiration_date,
    :beer_color,
    :beer_size
  
  validates_presence_of :bar_id,
    :special_description,
    :sale_price,
    :beer_color,
    :beer_size
  
  validates :sale_price,
    numericality: {greater_than: 0}

  validates :beer_color,
    numericality: {
      only_integer: true, 
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 3
    }

  validates :beer_size,
    numericality: {
      only_integer: true,
      greater_than: 0
    }

  def set_expiration_date
    self.expiration_date = DateTime.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9)
  end

  def active?
    self.expiration_date > Time.now
  end

  def end_special
    self.expiration_date = DateTime.now.yesterday.beginning_of_day.advance(hours: 9)
  end

  def reactivate_special
    self.set_expiration_date if bar.subscription.active?
  end

  def bar
    BarEntity.find bar_id
  end

  def location
    [bar_location.latitude, bar_location.longitude]
  end

  def distance_from(geopoint)
    Geocoder::Calculations.distance_between(location, geopoint).round(2)    
  end

  def beer_image
    case beer_color
    when 0
      'black.png'
    when 1
      'red.png'
    when 2
      'pale.png'
    when 3
      'amber.png'
    end
  end

  def self.format_attributes(attrs)
    attrs[:bar_name]   = BarEntity.find(attrs[:bar_id]).bar_name if attrs.has_key? :bar_id    
    attrs[:bar_location] = BarEntity.find(attrs[:bar_id]).bar_location if attrs.has_key? :bar_id
    attrs[:sale_price] = attrs[:sale_price].to_f if attrs.has_key?(:sale_price)
    attrs[:beer_color] = attrs[:beer_color].to_i if attrs.has_key?(:beer_color)
    attrs[:beer_size]  = attrs[:beer_size].to_i  if attrs.has_key?(:beer_size)
    attrs
  end
end
