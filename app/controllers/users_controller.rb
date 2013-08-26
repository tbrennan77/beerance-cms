class UsersController < ApplicationController
  before_filter :require_user, except: %w{new create}
  before_filter :require_admin, except: %w{new edit update create profile show current_specials archived_specials end_beerance reactivate_beerance}
  before_filter :verify_create_parameters, only: %w{create}  
  before_filter :confirm_active_subscription, only: %w{reactivate_beerance}  
  before_filter :confirm_correct_user_for_activation, only: %w{reactivate_beerance}

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
    @bar_special = BarSpecials.new
    redirect_to new_bar_entity_path unless current_user.bars?
  end

  def current_specials
    @bar_special = BarSpecials.new
  end

  def archived_specials
    @bar_special = BarSpecials.new
  end

# Basic CRUD actions
  def new
    redirect_to profile_path, notice: 'You already have an account' and return if current_user
    @user = User.new
    render layout: "application"
  end
    
  def create    
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
    params[:user][:username].downcase!
    @user = User.find params[:id]    
    if @user.update_attributes params[:user]
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
  def end_beerance
    @bar_special = BarSpecials.new
    special = BarSpecials.find params[:id]
    special.end_special
    if special.save
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
      respond_to do |format|
        format.js { flash.now.notice = "" }
        format.html { redirect_to profile_path, notice: 'Reactivated Special'}
      end
    else
      flash[:error] = "Something went wrong"
      redirect_to profile_path
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
  def verify_create_parameters
    @user = User.new(params[:user])
    @user.username.downcase!
    @user.newsletter_subscription = !@user.newsletter_subscription.to_i.zero?
    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add :password, "did not match confirmation."
      render 'new'
    end
    params[:user].delete :password_confirmation    
  end

  def confirm_correct_user_for_activation
    special = BarSpecials.find params[:id]
    redirect_to log_out_path unless special.bar.user.id == current_user.id
  end

  def confirm_active_subscription    
    bar = BarSpecials.find(params[:id]).bar
    
    if request.xhr?
      script = <<-END_SCRIPT
        $('.alert-box.notice').remove();
        $('#ajax_bar').before('<div class="alert-box notice">Your subscription is not active!</div>');
        $('.alert-box.notice').hide().fadeIn('slow').delay(4000).fadeOut();
      END_SCRIPT

      if !bar.subscription.active?
        render js: script
      end        
    else
      redirect_to profile_path, notice: 'Your subscription is not active' unless bar.subscription.active?
    end
  end
end
