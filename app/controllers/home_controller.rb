class HomeController < ApplicationController
  include GeoKit::Geocoders 
  layout 'interior'
  
  def index
    render layout: 'marketing'
  end

  def privacy
	  render layout: 'application'
  end

  def map
    miles = params[:distance] || 15
    zip = params[:zip] || 44114
    @location = get_geo(zip.to_s)
    bars = Bar.near(zip.to_s, miles.to_s)
    @specials = []
    @bars = []
    bars.each do |b| 
      b.bar_specials.each do |s|
        if s.active?
          @specials << s
          @bars << s.bar
        end
      end
    end
    @bars.uniq!
    render layout: 'mobile'
  end

  def bar_info
    @bar = Bar.find params[:id]
    render layout: false
  end

  def get_geo(info)
    geo = MultiGeocoder.geocode(info)
    location = {lat: geo.lat, lon: geo.lng, city: geo.city}
  end  
end
