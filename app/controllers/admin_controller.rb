class AdminController < ApplicationController
  before_filter :require_admin

  def index    
  end

  def user_index
    @users = User.all
  end

  def user_show
    @user = User.find params[:id]
    @customer = @user.stripe_customer
  end

  def news_subscriptions
    @news_subscriptions = NewsSubscription.all    
  end  
end
