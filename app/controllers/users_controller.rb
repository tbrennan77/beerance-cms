class UsersController < ApplicationController
  before_filter :require_user, except: %w{new create}
  before_filter :require_admin, except: %w{new create}

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def profile
    @user = current_user
    @bar_entities = BarEntity.where bar_owner_id: current_user.id
  end

  def new  
    @user = User.new  
  end  
    
  def create
    params[:user].asset_valid_keys %w{username password}
    @user = User.new(params[:user])  
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
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
end
