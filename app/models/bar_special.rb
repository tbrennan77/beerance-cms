class BarSpecial < ActiveRecord::Base
  belongs_to :bar
  belongs_to :user

  acts_as_mappable :through => :bar,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

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

  default_scope { order('bar_specials.updated_at DESC') }
  scope :active,   -> { where("expiration_date > '#{Time.now}'") }
  scope :inactive, -> { where("expiration_date < '#{Time.now}'") }

  before_create :set_expiration_date
  before_save :format_description

  def format_description
    self.description =
    self.description.split(' ').map(&:capitalize)
    .map{ |w| w = (/\AMc(.)/.match(w)) ? ("Mc" + w.gsub(/\AMc(.)/, '\1').capitalize) : w }
    .join(' ')
  end

  def bar_name
    bar.name
  end

  def lat
    bar.latitude
  end

  def lng
    bar.longitude
  end

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
    else
      errors.add :base, "Subscription is not active"
      return false
    end
    save
  end

  private
  
  def set_expiration_date
    self.expiration_date = Time.now.tomorrow.beginning_of_day.advance(hours: 9)
  end

  def end_special
    self.expiration_date = Time.now.yesterday.beginning_of_day.advance(hours: 9)
  end
  
  alias_method :reactivate_special, :set_expiration_date
end
