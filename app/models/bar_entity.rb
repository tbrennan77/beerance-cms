class BarEntity < ParseResource::Base
  include GeoKit::Geocoders

  fields :bar_owner_id,
        :stripe_card_token,
        :stripe_customer_id,
        :subscription_plan_id,
        :bar_name,
        :bar_phone,
        :bar_url,
        :bar_addr1,
        :bar_addr2,
        :bar_city,
        :bar_state,
        :bar_zip,
        :bar_location,
        :hours_mon,
        :hours_tues,
        :hours_wed,
        :hours_thur,
        :hours_fri,
        :hours_sat,
        :hours_sun,
        :mon_start,
        :mon_end,
        :tues_start,
        :tues_end,
        :wed_start,
        :wed_end,
        :thur_start,
        :thur_end,
        :fri_start,
        :fri_end,
        :sat_start,
        :sat_end,
        :sun_start,
        :sun_end  

  validates_presence_of :bar_name, :subscription_plan_id, :bar_location, :bar_phone, :bar_url, :bar_addr1, :bar_city, :bar_state, :bar_zip, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun    

  after_update :update_specials_after_change

  def update_specials_after_change
    if (self.bar_addr1_changed?)
      set_geo_location
      update_specials
    end
  end

  def bar_owner
    User.find(bar_owner_id)
  end

  def bar_owner=(user)
    self.bar_owner_id = user.id
  end

  def set_url
    self.bar_url = "http://#{self.bar_url.gsub(/(https:\/\/|http:\/\/)/,'')}"
  end

  def location
    MultiGeocoder.geocode("#{a.bar_addr1}, #{a.bar_city}, #{a.bar_state} #{a.bar_zip}")
  end

  def set_geo_location       
    if location
      self.bar_location = ParseGeoPoint.new(latitude: location.lat, longitude: location.lng)
    else
      errors[:base] << "Geocoding faild. Please check address."
      return false
    end    
  end

  def update_specials
    specials = BarSpecials.where(bar_id: self.id)
    if specials
      specials.each do |s|
        s.bar_location = self.bar_location
        s.save
      end
    end
  end

  def bar_specials
    BarSpecials.where(bar_id: self.id)
  end

  def user
    User.find self.bar_owner_id
  end

  def set_bar_owner(id)
    self.bar_owner_id = id
  end

  def format_fields    
    set_url
    set_geo_location
    update_specials
  end

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

  def update_card(strip_card_token)    
    unless stripe_customer_id.nil?      
      stripe_customer.card = stripe_card_token
      stripe_customer.save
    end
    true
  rescue Stripe::StripeError => e
    log_stripe_error("Unable to update your card. #{e.message}.")    
  end
  
  def cancel_subscription    
    customer = Stripe::Customer.retrieve(stripe_customer_id)      
    if customer.subscription.status == 'active'
      customer.cancel_subscription(at_period_end: true)
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

  def active_subscription?
    unless subscription
      return false
    end
    subscription.active?
  end

  def subscription_plan
    SubscriptionPlan.find subscription_plan_id
  end

  def subscription_plan=(subscription_plan)
    self.subscription_plan_id = subscription_plan.id
  end

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(
        card:  self.stripe_card_token,
        plan:  self.subscription_plan.name,
        email: self.user.username,
        description: self.bar_name
      )
      #charge = Stripe::Charge.create(
      #  customer:    customer.id,
      #  amount:      self.subscription_plan.amount,
      #  description: self.bar_name,
      #  currency:    'usd'
      #)
      self.stripe_card_token = nil
      self.stripe_customer_id = customer.id
      set_url
      set_geo_location
      self.save
    end
  rescue Stripe::InvalidRequestError => e    
    errors.add :base, "There was a problem with your credit card."
    false
  end

  private 
  
  def log_stripe_error(e, message)
    logger.error "Stripe Error: " + e.message
    errors.add :base, message
    false
  end

  alias :user= :bar_owner=
end
