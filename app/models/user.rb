class User < ParseUser
  fields :email, :username, :run_count, :owner_name, :owner_phone, :account_type, :expiration_date, :user_favorites, :createdAt

  validates_presence_of :username, :password, :owner_name, :owner_phone
end