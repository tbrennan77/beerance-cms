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
  
  def remember_location
    session[:back_paths] ||= []
    unless session[:back_paths].last == request.fullpath
      session[:back_paths] << request.fullpath
    end

    # make sure that the array doesn't bloat too much
    session[:back_paths] = session[:back_paths][-10..-1]
  end

  def back
    session[:back_paths] ||= []
    session[:back_paths].pop || :back
  end  
end  