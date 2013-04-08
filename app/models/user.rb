class User < ParseUser
  attr_accessor :stripe_card_token, :plan_type
  fields :email, :newsletter_subscription, :username, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt, :admin, :stripe_customer_id

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :username, presence: true, length: {maximum: 100}, format: {with: EMAIL_REGEX}
  validates :password, presence: true, length: {minimum: 6}  
  validates :owner_name, presence: true
  validates :owner_phone, presence: true
  validates :plan_type, presence: true

  def admin?; self.admin ? true : false; end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end

  def save_with_payment
    if valid? && find_plan
      plan = find_plan
      customer = Stripe::Customer.create(
        :card  => stripe_card_token,
        :plan  => plan[:plan_id],
        :email => username
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => plan[:amount],
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
      self.stripe_customer_id = customer.id
      self.save
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def find_plan
    # Amount in cents
    case plan_type.to_i
    when 1
      {amount: 3000, plan_id: '3_months'}
    when 2
      {amount: 5700, plan_id: '6_months'}
    when 3
      {amount: 10200, plan_id: '12_months'}    
    else
      false
    end
  end
end