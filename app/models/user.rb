class User < ParseUser  
  fields :email, :newsletter_subscription, :username, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt, :admin, :stripe_customer_id, :subscription_plan_id, :password_reset_token, :password_reset_sent_at

  EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  validates :username,
    presence: true,    
    length: {maximum: 100},
    format: {with: EMAIL_REGEX}
  
  validates :password,
    presence: true,
    length: {minimum: 6},
    on: :create
  
  validates_presence_of :owner_name, :owner_phone, :subscription_plan_id

  def admin?; self.admin==true; end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(
        card:  stripe_card_token,
        plan:  s.plan.name,
        email: username
      )
      charge = Stripe::Charge.create(
        customer:    customer.id,
        amount:      s.plan.amount,
        description: 'Beerance Subscription',
        currency:    'usd'
      )
      self.stripe_customer_id = customer.id
      self.save
    end
  rescue Stripe::InvalidRequestError => e    
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def phone
    owner_phone.gsub(/[^\d]/, '')
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def password_reset_sent_at
    Time.parse self.attributes["password_reset_sent_at"]["iso"]
  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save
    Notifier.password_reset(self).deliver
  end

  def bars
    BarEntity.where(bar_owner_id: id)
  end

  def subscription
    Subscription.find_by_user_id id
  end

  def update_plan(plan)    
    unless stripe_customer_id.nil?
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.update_subscription(:plan => plan.name)
      self.subscription_plan_id = plan.id
      self.save
    end
    true
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to update your subscription. #{e.message}."
    false
  end

  def update_card(strip_card_token)    
    unless stripe_customer_id.nil?      
      stripe_customer.card = stripe_card_token
      stripe_customer.save
    end
    true
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to update your card. #{e.message}."
    false
  end

  def cancel_subscription    
    customer = Stripe::Customer.retrieve(stripe_customer_id)      
    if customer.subscription.status == 'active'
      customer.cancel_subscription(at_period_end: true)
    end 
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end

  def stripe_customer
    Stripe::Customer.retrieve self.stripe_customer_id
  end

  def subscription
    Subscription.new(stripe_customer.subscription)
  end

  def subscription_plan
    SubscriptionPlan.find subscription_plan_id
  end
end