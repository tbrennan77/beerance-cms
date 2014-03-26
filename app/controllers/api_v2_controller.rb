class ApiV2Controller < ApplicationController
  respond_to :json

  def show_bar
    @bar=Bar.find(params[:id])    
    respond_with(@bar, methods: [:nice_url, :monday_hours, :tuesday_hours, :wednesday_hours, :thursday_hours, :friday_hours, :saturday_hours, :sunday_hours] )
  end

  def show_specials
    @specials = Bar.includes(:bar_specials).find(params[:id]).bar_specials.where("expiration_date > ?", Time.now)
    respond_with(@specials, methods: [:bar_name])
  end

  def specials_near_zip    
    miles     = params[:miles] || 15
    zip       = params[:zip]   || 44114    
    bar_ids   = Bar.near(zip, miles).map(&:id)

    @specials = BarSpecial.where("bar_id IN (?) AND expiration_date > ?", bar_ids, Time.now)
    respond_with(@specials, methods: [:bar_name, :lat, :lng])
  end
end
