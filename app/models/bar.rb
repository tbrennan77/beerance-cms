class Bar < ActiveRecord::Base
  include GeoKit::Geocoders

  belongs_to :user
  belongs_to :subscription_plan
  has_many :bar_specials

  attr_accessor :stripe_card_token

  validates_presence_of :name,
    :subscription_plan_id,
    :phone,
    :url,
    :address,
    :city,
    :state,
    :zip,
    :latitude,    
    :sunday_start,
    :sunday_end,
    :monday_start,
    :monday_end,
    :tuesday_start,
    :tuesday_end,
    :wednesday_start,
    :wednesday_end,
    :thursday_start,
    :thursday_end,
    :friday_start,
    :friday_end,
    :saturday_start,
    :saturday_end

  def nice_url
    "http://#{self.url.gsub(/(https:\/\/|http:\/\/)/,'')}"
  end

  # Update the STRIP API plan
  def update_plan(plan)    
    unless stripe_customer_id.nil?
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.update_subscription(plan: plan.name, trial_end: 'now')
      self.subscription_plan_id = plan.id
      self.save
    end
    true
  rescue Stripe::StripeError => e
    log_stripe_error(e, "Unable to update your subscription. #{e.message}.")
  end

  # Update the STRIP API card
  def update_card(strip_card_token)    
    unless stripe_customer_id.nil?      
      stripe_customer.card = stripe_card_token
      stripe_customer.save
    end
    true
  rescue Stripe::StripeError => e
    log_stripe_error("Unable to update your card. #{e.message}.")    
  end

  # Cancel the STRIP API plan
  def cancel_subscription    
    if stripe_customer.subscription.status == 'active'
      stripe_customer.cancel_subscription(at_period_end: true)
    end 
  rescue Stripe::StripeError => e
    log_stripe_error(e, "Unable to cancel your subscription. #{e.message}.")    
  end

  def stripe_customer
    Stripe::Customer.retrieve self.stripe_customer_id
  end

  def subscription
    Subscription.new(stripe_customer.subscription)
  end

  def save_with_payment
    set_geo_location
    
    if valid?
      create_stripe_customer
      create_parse_bar
      self.save
    end
  end

  def update_and_sync_with_parse(params)
    update_attributes(params)
    update_parse_bar
  end

  def active_subscription?
    unless subscription
      return false
    end
    subscription.active?
  end

  private

  def location
    MultiGeocoder.geocode("#{address}, #{city}, #{state} #{zip}")
  end

  def set_geo_location
    unless location.lat.blank?
      self.latitude  = location.lat
      self.longitude = location.lng
    else
      self.errors.add :base, "geocoding faild. Please check address."
      return false
    end    
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(
        card:  self.stripe_card_token,
        plan:  self.subscription_plan.name,
        email: self.user.email,
        description: self.name
      )
    self.stripe_customer_id = customer.id    
    rescue Stripe::InvalidRequestError => e    
      errors.add :base, "There was a problem with your credit card."
      false
  end

  def create_parse_bar
    bar = BarEntity.create(parse_bar_params)
    self.parse_bar_id = bar.id
  end

  def update_parse_bar
    bar = BarEntity.find(self.parse_bar_id)
    bar.update_attributes(parse_bar_params)
  end

  def parse_bar_params
    { bar_addr1: self.address,
      bar_addr2: self.address_2,        
      bar_city: self.city,
      bar_location: ParseGeoPoint.new(latitude: self.latitude, longitude: self.longitude),        
      bar_name: self.name,
      bar_owner_id: self.user_id,
      bar_phone: self.phone,
      bar_state: self.state,
      bar_url: self.nice_url,
      bar_zip: self.zip,
      hours_sun:  cat_times(self.sunday_start, self.sunday_end),
      hours_mon:  cat_times(self.monday_start, self.monday_end),
      hours_tues: cat_times(self.tuesday_start, self.tuesday_end),
      hours_wed:  cat_times(self.wednesday_start, self.wednesday_end),
      hours_thur: cat_times(self.thursday_start, self.thursday_end),
      hours_fri:  cat_times(self.friday_start, self.friday_end),
      hours_sat:  cat_times(self.saturday_start, self.saturday_end) 
    }
  end

  def cat_times(open, close)
    (open == "Closed" || close == "Closed") ? "Closed" : "#{open} - #{close}"    
  end
end
