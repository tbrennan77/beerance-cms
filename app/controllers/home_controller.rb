class HomeController < ApplicationController
	
  layout 'interior'
  
  def index
    render layout: 'marketing'
  end

  def privacy
	  render layout: 'application'
  end
end
