class UsersController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, only: %w{index admin_show destroy make_admin remove_admin}
  before_filter :new_bar_special, only: %w{profile current_specials}

  def index
    @users = User.all
  end

  def admin_show
    @user = User.find params[:id]
    @customer = Stripe::Customer.retrieve @user.stripe_customer_id
  end

  def show        
  end

  def profile    
    redirect_to new_bar_path if current_user.bars.blank?
  end

# Basic CRUD actions
  def edit
    @user = User.find params[:id]
    render layout: 'account_details'
  end

  def update    
    @user = User.find params[:id]    
    if @user.update_attributes(user_params)
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
  def new_bar_special
    @bar_special = BarSpecial.new    
  end
end
