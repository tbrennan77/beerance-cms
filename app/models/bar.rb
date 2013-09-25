class Bar < ActiveRecord::Base
  include GeoKit::Geocoders

  belongs_to :user
  belongs_to :subscription_plan
  has_many :bar_specials

  reverse_geocoded_by :latitude, :longitude

  attr_accessor :stripe_card_token

  validates_presence_of :subscription_plan_id, message: 'should be selected'
  validates_presence_of :name,    
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
    elsif stripe_customer.subscription.status == 'trialing'
      stripe_customer.cancel_subscription(at_period_end: false)
    end 
  rescue Stripe::StripeError => e
    log_stripe_error(e, "Unable to cancel your subscription. #{e.message}.")    
  end

  def stripe_customer
    Stripe::Customer.retrieve self.stripe_customer_id unless stripe_customer_id.blank?
  end

  def subscription
    Subscription.new(stripe_customer.subscription) if stripe_customer
  end

  def monday_hours
    cat_times(self.monday_start, self.monday_end)
  end

  def tuesday_hours
    cat_times(self.tuesday_start, self.tuesday_end)
  end

  def wednesday_hours
    cat_times(self.wednesday_start, self.wednesday_end)
  end

  def thursday_hours
    cat_times(self.thursday_start, self.thursday_end)
  end

  def friday_hours
    cat_times(self.friday_start, self.friday_end)
  end

  def saturday_hours
    cat_times(self.saturday_start, self.saturday_end) 
  end

  def sunday_hours
    cat_times(self.sunday_start, self.sunday_end) 
  end

  def save_with_payment
    set_geo_location
    
    if valid?
      create_stripe_customer
      self.save
    end
  end

  def active_subscription?
    unless subscription
      return user.admin?
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
    return true if user.admin?
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

  def cat_times(open, close)
    (open == "Closed" || close == "Closed") ? "Closed" : "#{open} - #{close}"    
  end
end
