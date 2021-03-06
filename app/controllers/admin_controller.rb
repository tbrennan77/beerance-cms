class AdminController < ApplicationController
  before_filter :require_admin

  def feedback
    @feedbacks = Feedback.all
  end

  def user_index
    @users = User.all
  end

  def user_show
    @user = User.find params[:id]    
  end

  def news_subscriptions
    @owner_news_subscriptions = NewsSubscription.where(subscriber_type: 'bar_owner')
    @drinker_news_subscriptions = NewsSubscription.where(subscriber_type: 'bar_drinker')
  end

  def test_feedback
    Notifier.feedback(Feedback.first).deliver
    redirect_to test_email_path, notice: 'Test email sent!'
  end

  def test_password_change
    Notifier.password_changed(current_user).deliver
    redirect_to test_email_path, notice: 'Test email sent!'
  end

  def test_password_reset
    Notifier.password_reset(current_user).deliver
    redirect_to test_email_path, notice: 'Test email sent!'
  end

  def test_signup
    Notifier.signup(current_user).deliver
    redirect_to test_email_path, notice: 'Test email sent!'
  end

  def impersonate
    user = User.find params[:id]
    env['warden'].set_user user
    redirect_to admin_users_path, notice: "You are now impersonating #{user.name}"
  end
end
