class HomeController < ApplicationController
	
  layout 'interior'
  
  def index
	  render layout: 'application'
  end
end
