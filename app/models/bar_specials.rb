class BarSpecials < ParseResource::Base
  include GeoKit::Geocoders
  fields :bar_id,
    :bar_location,
    :bar_name,
    :special_description,
    :sale_price,
    :expiration_date,
    :beer_color,
    :beer_size
  
  validates_presence_of :special_description,
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

  def active?
    self.expiration_date > Time.now
  end  

  def toggle_activation
    if active?
      end_special
    elsif bar.active_subscription?
      reactivate_special
    end
    save
  end

  def distance_from(geopoint)    
    bar.location.distance_from(geopoint, unit: :miles).round(2)
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

  def save_and_format
    # Precondition check
    if !bar.active_subscription?
      return false
    end
    set_expiration_date
    set_bar_info
    enforce_types
    save
  end

  def bar
    BarEntity.find bar_id
  end

  def bar_entity=(bar_entity)
    self.bar_id = bar_entity.id
  end  

  private

  def set_expiration_date
    self.expiration_date = DateTime.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9)
  end

  def set_bar_info
    self.bar_name = self.bar.bar_name
    self.bar_location = ParseGeoPoint.new(latitude: self.bar.bar_location.latitude, longitude: self.bar.bar_location.longitude)
  end

  def enforce_types
    self.sale_price = self.sale_price.to_f
    self.beer_color = self.beer_color.to_i
    self.beer_size = self.beer_size.to_i
  end

  def end_special
    self.expiration_date = DateTime.now.yesterday.beginning_of_day.advance(hours: 9)
  end

  alias_method :reactivate_special, :set_expiration_date
end
