class ApiController < ApplicationController
  respond_to :json

  def show_bar
    @bar=Bar.find(params[:id])
    respond_with(@bar, include: :bar_specials, methods: [:monday_hours, :tuesday_hours, :wednesday_hours, :thursday_hours, :friday_hours, :saturday_hours, :sunday_hours] )
  end

  def show_specials
    bar=Bar.find(params[:id])
    @specials = bar.bar_specials.active
    respond_with(@specials)
  end

  def specials_near_zip
    miles = params[:miles] || 15
    zip = params[:zip] || 44114
    bars = Bar.near(zip, miles)
    @specials = []
    bars.each { |b| b.bar_specials.each {|s| @specials << s if s.active? }}
    respond_with(@specials, methods: [:bar_name, :lat, :lng])
  end
end