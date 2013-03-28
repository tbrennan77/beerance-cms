class ApplicationController < ActionController::Base  
  protect_from_forgery  
  helper_method :current_user  
    
  private  
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end  

  def require_user
    if current_user.blank?
      redirect_to root_path, :notice => "You must log in"
    end
  end

  def require_admin
    if current_user.blank? || current_user.admin? == false
      flash[:errors] = "You are not authorized. This incident will be reported."
      redirect_to root_path
    end
  end
end  