class User < ParseUser
  fields :email, :username, :run_count, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt, :admin  
  validates_presence_of :username, :password, :owner_name, :owner_phone, on: :create

  def admin?; self.admin ? true : false; end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end
end