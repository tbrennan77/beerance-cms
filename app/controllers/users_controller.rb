class UsersController < ApplicationController
  before_filter :require_user, except: %w{new create}
  before_filter :require_admin, except: %w{new edit update create profile show current_specials archived_specials bars end_beerance reactivate_beerance}
  before_filter :verify_create_parameters, only: %w{create}
  before_filter :get_specials, only: %w{profile current_specials archived_specials bars}
  before_filter :confirm_active_subscription, only: %w{reactivate_beerance}  

  def index
    @users = User.all
  end

  def admin_show
    @user = User.find params[:id]
    @customer = Stripe::Customer.retrieve @user.stripe_customer_id
  end

  def show    
    @total_specials = 0
    bar_entities = BarEntity.where(bar_owner_id: current_user.id)

    bar_entities.each do |be|
      @total_specials += be.bar_specials.count
    end
    
    @total_bars = bar_entities.count
    respond_to do |format|
        format.js
        format.html
      end 
  end

  def profile
    @bar_entity = BarEntity.new
    @bar_special = BarSpecials.new
  end

  def bars
    @bar_entity = BarEntity.new  
  end

  def current_specials
    @bar_special = BarSpecials.new
  end

  def archived_specials
    @bar_special = BarSpecials.new
  end

  def new  
    @user = User.new
  end  
    
  def create    
    if @user.save_with_payment
      session[:user_id] = @user.id
      Notifier.signup(@user).deliver
      redirect_to profile_path
    else
      render "new"
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def end_beerance
    @bar_special = BarSpecials.new
    special = BarSpecials.find params[:id]
    special.end_special
    if special.save
      get_specials
      respond_to do |format|
        format.js { flash.now.notice = "Ended Special" }
        format.html {redirect_to profile_path, notice: 'Ended Special'}
      end      
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
    end
  end

  def reactivate_beerance
    @bar_special = BarSpecials.new
    special = BarSpecials.find params[:id]
    special.reactivate_special
    if special.save
      get_specials
      respond_to do |format|
        format.js { flash.now.notice = "Reactivated Special" }
        format.html { redirect_to profile_path, notice: 'Reactivated Special'}
      end
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
    end
  end

  def update
    params[:user][:username].downcase!
    @user = User.find params[:id]    
    if @user.update_attributes params[:user]
      redirect_to profile_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
    redirect_to users_path
  end

  def make_admin
    user = User.find params[:id]
    user.make_admin
    redirect_to users_path, notice: 'Updated User'
  end

  def remove_admin
    user = User.find params[:id]
    user.remove_admin
    redirect_to users_path, notice: 'Updated User'
  end

  def verify_create_parameters
    @user = User.new(params[:user])
    @user.stripe_card_token = params[:user][:stripe_card_token]    
    @user.subscription_plan_id = params[:user][:subscription_plan_id]    
    @user.username.downcase!
    @user.newsletter_subscription = !@user.newsletter_subscription.to_i.zero?
    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add :password, "did not match confirmation."
      render 'new'
    end
    params[:user].delete :password_confirmation
    params[:user].delete :stripe_card_token
  end

  def get_specials
    @bar_entities = BarEntity.where bar_owner_id: current_user.id
    @active_specials = []
    @inactive_specials = []
    
    @bar_entities.each do |be|
      be.bar_specials.each do |s|
        if s.active?
          @active_specials << s
        else
          @inactive_specials << s
        end
      end
    end
  end

  def confirm_active_subscription    
    unless current_user.subscription.active?
      redirect_to billing_path, notice: 'Reactivate your account to post beerances'
    end
  end
end
