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
    @owner_news_subscriptions = NewsSubscription.where(subscriber_type: 'bar_owner')
    @drinker_news_subscriptions = NewsSubscription.where(subscriber_type: 'bar_drinker')
  end

  def send_test_email
    Notifier.test_email(params[:email]).deliver
    redirect_to test_email_path, notice: 'Test email sent!'
  end
end
