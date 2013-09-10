class ApplicationController < ActionController::Base  
  protect_from_forgery  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  private

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :name, :phone, :newsletter_subscription) }
  end
end  
