class Bar < ActiveRecord::Base
  include GeoKit::Geocoders

  belongs_to :user
  belongs_to :subscription_plan

  attr_accessor :stripe_card_token

  validates_presence_of :name,
    :phone,
    :url,
    :address,
    :city,
    :state,
    :zip,
    :latitude,
    :longitude,
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

  def url
    "http://#{self.bar_url.gsub(/(https:\/\/|http:\/\/)/,'')}"
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
        description: self.bar_name
      )
    self.stripe_customer_id = customer.id
    self.stripe_card_token  = nil
    rescue Stripe::InvalidRequestError => e    
      errors.add :base, "There was a problem with your credit card."
      false
  end
end
