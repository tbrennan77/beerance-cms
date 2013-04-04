class User < ParseUser
  fields :email, :username, :run_count, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt, :admin, :stripe_customer_id, :mon_start, :mon_end 
  
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates_presence_of :password, :owner_name, :owner_phone, on: :create
  validates :username, presence: true, length: {maximum: 100}, format: {with: EMAIL_REGEX}
  validates :password, length: {minimum: 6}, on: :create

  def admin?; self.admin ? true : false; end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end
end