class UsersController < ApplicationController
  before_filter :require_user, except: %w{new create}
  before_filter :require_admin, except: %w{new edit update create profile show current_specials archived_specials toggle_beerance}  
  before_filter :new_bar_special, only: %w{profile current_specials archived_specials toggle_beerance}

  def index
    @users = User.all
  end

  def admin_show
    @user = User.find params[:id]
    @customer = Stripe::Customer.retrieve @user.stripe_customer_id
  end

  def show    
    render layout: 'account_details'    
  end

  def profile    
    redirect_to new_bar_entity_path unless current_user.bars?
  end

# Basic CRUD actions
  def new
    redirect_to profile_path, notice: 'You already have an account' and return if current_user
    @user = User.new
    render layout: "application"
  end
    
  def create
    @user = User.new user_params    
    if @user.save
      session[:user_id] = @user.id
      Notifier.signup(@user).deliver
      redirect_to bar_entities_path
    else
      render "new"
    end
  end

  def edit
    @user = User.find params[:id]
    render layout: 'account_details'
  end

  def update    
    @user = User.find params[:id]    
    if @user.update_attributes user_params
      redirect_to account_details_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
    redirect_to users_path
  end

# Beerance Actions
  def toggle_beerance
    @special = current_user.specials.find { |d| d.id == params[:id] }
    @special.active? ? @special.end_special : @special.reactivate_special
    if @special.save
      respond_to do |format|
        format.js   { flash.now.notice = "Updated Special" }
        format.html { redirect_to profile_path, notice: 'Updated Special' }
      end
    end
  end

# Admin Actions
  def make_admin
    user = User.find params[:id]
    user.make_admin
    redirect_to admin_users_path, notice: 'Updated User'
  end

  def remove_admin
    user = User.find params[:id]
    user.remove_admin
    redirect_to admin_users_path, notice: 'Updated User'
  end

# Before Filters
  def user_params
    params[:user][:username] = params[:user][:username].downcase if params[:user].has_key?(:username)
    params[:user][:newsletter_subscription] = !params[:user][:newsletter_subscription].to_i.zero? if params[:user].has_key?(:newsletter_subscription)
    params[:user]
  end

  def new_bar_special
    @bar_special = BarSpecials.new    
  end
end
