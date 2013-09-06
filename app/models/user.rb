class User < ParseUser
  fields :email, :newsletter_subscription, :username, :owner_name, :owner_phone, :account_type, :user_favorites, :createdAt, :admin, :password_reset_token, :password_reset_sent_at

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :username,
    presence: true,    
    length: {maximum: 100},
    format: {with: EMAIL_REGEX}
  
  validates :password,
    presence: true,
    length: {minimum: 6}
  
  validates_presence_of :owner_name, :owner_phone

  def admin?; self.admin==true; end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end

  def phone
    owner_phone.gsub(/[^\d]/, '')
  end

  def update_password(new_password)    
    if password_reset_sent_at < 2.hours.ago || admin?
      return "Password reset has expired."
    end
    self.password = new_password
    if self.valid?
      self.save
      Notifier.password_changed(self).deliver      
      "Password successfully reset." 
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def password_reset_sent_at    
    Time.parse(self.attributes["password_reset_sent_at"]["iso"])
  end

  def send_password_reset    
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    if self.save
      Notifier.password_reset(self).deliver if admin?
    else
      raise "#{self.errors.full_messages}"
    end
  end

  def bars
    BarEntity.where(bar_owner_id: id)
  end

  def specials
    specials = []
    bars.each do |bar|
      bar.bar_specials.each {|s| specials << s }
    end
    specials
  end

  def active_specials
    active_specials = []
    specials.each {|s| active_specials << s if s.active? }
    active_specials
  end

  def inactive_specials
    inactive_specials = []
    specials.each {|s| inactive_specials << s unless s.active? }
    inactive_specials
  end

  def bars?
    bars.count > 0 ? true : false
  end
end
