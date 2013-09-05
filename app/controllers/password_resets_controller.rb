class PasswordResetsController < ApplicationController
  before_filter :check_password, :only => %w{update}  
    
  def new
  end
  
  def create
    user = User.find_by_username params[:email].downcase    
    user.send_password_reset if user
    redirect_to root_path, notice: "If this email exists in our system, we've sent you a password reset link."
  end
  
  def edit
    @user = User.find_by_password_reset_token params[:id]
    redirect_to new_password_reset_path unless @user
  end  
  
  def update
    @user = User.find_by_password_reset_token params[:id]
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to root_path, notice: "Password reset has expired."
    elsif @user.update_attributes params[:user]
      Notifier.password_changed(@user).deliver
      redirect_to root_path, notice: "Password successfully reset."      
    else
      render "edit"
    end
  end
  
  private
  
  def check_password 
    @user = User.find_by_password_reset_token params[:id]
    if params[:user][:password] != params[:user][:password_confirmation]
      @password_error = "Password does not match confirmation."
      flash[:error] = @password_error
      render "edit"
    elsif params[:user][:password].length < 5
      @password_error = "Password must be at least 5 characters long."
      flash[:error] = @password_error
      render "edit"
    end
  end  
end
