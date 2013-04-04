class UsersController < ApplicationController
  before_filter :require_user, except: %w{new create}
  before_filter :require_admin, except: %w{new create profile}
  before_filter :verify_create_parameters, only: %w{create}

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def profile
    @bar_entity = BarEntity.new
    @bar_special = BarSpecial.new
    @bar_entities = BarEntity.where bar_owner_id: current_user.id    
    @active_specials = []
    @inactive_specials = []
    
    @bar_entities.each do |be|
      specials = BarSpecial.where(bar_id: be.id)
      if specials
        specials.each do |s|
          if s.active?
            @active_specials << s
          else
            @inactive_specials << s
          end
        end
      end
    end
  end

  def new  
    @user = User.new  
  end  
    
  def create    
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      Notifier.signup(@user).deliver
      redirect_to new_charge_path
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    params[:user][:username].downcase!
    @user = User.find(params[:id])
    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    if @user.valid?
      @user.save
      redirect_to users_path
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
    params[:user].assert_valid_keys %w{username password owner_name owner_phone password_confirmation}    
    if params[:user][:password] != params[:user][:password_confirmation]
      @user = User.new(params[:user])
      @user.errors.add :password, "did not match confirmation."
      render 'new'
    end
    params[:user].delete :password_confirmation
    params[:user][:username].downcase!
  end
end
