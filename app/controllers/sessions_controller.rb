class SessionsController < ApplicationController
  def new  
  end  
    
  def create  
    user = User.authenticate(params[:email].downcase, params[:password])  
    if user  
      session[:user_id] = user.id
      redirect_to profile_path, :notice => "Logged in!"  
    else  
      flash[:error] = "Invalid email or password"  
      render "new"  
    end  
  end 

  def destroy  
  	session[:user_id] = nil  
  	redirect_to root_url, :notice => "Logged out!"  
	end 
end
