class BarSpecial < ActiveRecord::Base
  belongs_to :bar
  belongs_to :user

  validates_presence_of :bar_id, :description
  
  validates :sale_price,
    presence: true,
    numericality: {greater_than: 0}

  validates :beer_color,
    presence: true,
    numericality: {
      only_integer: true, 
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 3
    }

  validates :beer_size,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0
    }

  scope :active,   -> { where("expiration_date > '#{Time.now}'") }
  scope :inactive, -> { where("expiration_date < '#{Time.now}'") }

  before_create :set_expiration_date

  def active?
    self.expiration_date > Time.now
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

  def toggle_activation
    if active?
      end_special
    elsif bar.active_subscription?
      reactivate_special
    end
    save
    update_parse_bar_special
  end

  def save_with_parse
    if valid?
      create_parse_bar_special
      self.save
    end
  end

  def update_with_parse(params)
    update_attributes(params)
    update_parse_bar_special
  end
  
  private
  
  def set_expiration_date
    self.expiration_date = DateTime.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9)
  end

  def end_special
    self.expiration_date = DateTime.now.yesterday.beginning_of_day.advance(hours: 9)
  end

  def create_parse_bar_special
    bar_sepcial = BarSpecials.create(parse_bar_special_params)
    self.parse_bar_special_id = bar_sepcial.id
  end

  def update_parse_bar_special
    bar_special = BarSpecials.find(self.parse_bar_special_id)
    bar_special.update_attributes(parse_bar_special_params)
  end

  def parse_bar_special_params
    { bar_id: self.bar.parse_bar_id,
      bar_location: ParseGeoPoint.new(latitude: self.bar.latitude, longitude: self.bar.longitude),
      bar_name: self.bar.name,
      beer_color: self.beer_color,
      beer_size: self.beer_size,
      expiration_date: self.expiration_date || DateTime.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9),
      sale_price: self.sale_price.to_f,
      special_description: self.description
    }
  end

  alias_method :reactivate_special, :set_expiration_date
end
