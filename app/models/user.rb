class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessible :email, :password, :password_confirmation, :name, :phone, :newsletter_subscription, :admin

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone, :password
  validates_confirmation_of :password
  
  def admin?() admin end
  def make_admin; self.admin=true;self.save; end
  def remove_admin; self.admin=false;self.save; end

  def bars
    BarEntity.where(user_id: id)
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
