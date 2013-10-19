class ApiController < ApplicationController
  respond_to :json

  def show_bar
    @bar=Bar.find(params[:id])
    respond_with(@bar, methods: [:nice_url, :monday_hours, :tuesday_hours, :wednesday_hours, :thursday_hours, :friday_hours, :saturday_hours, :sunday_hours] )
  end

  def show_specials
    bar=Bar.find(params[:id])
    @specials = []
    bar.bar_specials.active.each {|s| @specials << {bar_special: s} }
    respond_with(@specials, methods: [:bar_name])
  end

  def specials_near_zip
    miles = params[:miles] || 15
    zip = params[:zip] || 44114
    bars = Bar.near(zip, miles)
    @specials = []
    bars.each { |b| b.bar_specials.each {|s| @specials << {bar_special: s} if s.active? }}
    respond_with(@specials, methods: [:bar_name, :lat, :lng])
  end
end
