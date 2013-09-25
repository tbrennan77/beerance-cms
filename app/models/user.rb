class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :name, :phone, :newsletter_subscription, :admin

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create

  has_many :bars
  has_many :bar_specials, through: :bars
  
  default_scope order('created_at ASC')
  
  def admin?() admin end
  def make_admin() update_attributes(admin: true) end  
  def remove_admin() update_attributes(admin: false) end
end
