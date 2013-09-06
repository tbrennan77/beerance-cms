class PasswordResetsController < ApplicationController
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
    check_password
    @user = User.find_by_password_reset_token params[:id]
    notice = @user.update_password(params[:user][:password])
    redirect_to root_path, notice: notice
  end
  
  private
  
  def check_password
    @user = User.find_by_password_reset_token params[:id]
    if params[:user][:password] != params[:user][:password_confirmation]
      @password_error = "Password does not match confirmation."
      flash[:error] = @password_error
      render "edit"
    elsif params[:user][:password].length < 6
      @password_error = "Password must be at least 6 characters long."
      flash[:error] = @password_error
      render "edit"
    end
  end  
end
