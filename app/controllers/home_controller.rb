class HomeController < ApplicationController
	
  layout 'interior'
  
  def index
    render layout: 'marketing'
  end

  def privacy
	  render layout: 'application'
  end

  def send_feedback
    feedback = {
      name: params[:name],
      email: params[:email],
      phone: params[:phone],
      category: params[:category],
      comment: params[:comment]
    }    
    Notifier.feedback(feedback).deliver
    redirect_to root_path, notice: 'Thank you for your feedback!'
  end
end
