class User < ParseUser
  attr_accessor :stripe_card_token
  fields :email, :newsletter_subscription, :username, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt, :admin, :stripe_customer_id, :subscription_plan_id

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
      self.save
      s = Subscription.create subscription_plan_id: self.subscription_plan_id, user_id: self.id
      s.set_expiration

      customer = Stripe::Customer.create(
        card:  stripe_card_token,
        plan:  s.plan.name,
        email: username
      )
      charge = Stripe::Charge.create(
        customer:    customer.id,
        amount:      s.plan.amount,
        description: 'Rails Stripe customer',
        currency:    'usd'
      )
      self.stripe_customer_id = customer.id
      self.save
    end
  rescue Stripe::InvalidRequestError => e    
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def bars
    BarEntity.where(bar_owner_id: id)
  end

  def subscription
    Subscription.find_by_user_id id
  end
end