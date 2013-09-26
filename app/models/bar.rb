class Bar < ActiveRecord::Base
  include GeoKit::Geocoders

  belongs_to :user
  belongs_to :subscription_plan
  has_many :bar_specials

  reverse_geocoded_by :latitude, :longitude

  attr_accessor :stripe_card_token, :coupon

  VALID_COUPON_CODES = %w{rockyriver beerance3months beerance6months}

  validates :coupon, inclusion: { in: VALID_COUPON_CODES, message: "code could not be found or is no longer valid", allow_nil: true}
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

  default_scope order('created_at ASC')
  before_validation :clean_coupon_code

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
    case stripe_customer.subscription.status
      when 'active'
        stripe_customer.cancel_subscription(at_period_end: true)
      when 'trialing'
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

  [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday].each do |day|
    define_method :"#{day}_hours" do      
      cat_times(self.send("#{day}_start"), self.send("#{day}_end"))
    end
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

  def clean_coupon_code    
    self.coupon = self.coupon.blank? ? nil : self.coupon.downcase
  end

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
    # Admin are free
    return true if user.admin?
    
    customer = Stripe::Customer.create(
      card:  self.stripe_card_token,
      coupon: self.coupon,
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
