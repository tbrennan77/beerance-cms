class BarEntity < ParseUser
  # For phone number formatting
  include ActionView::Helpers
  include Geokit::Geocoders
  
  fields :bar_owner_id, :bar_name, :bar_phone, :bar_url, :bar_addr1, :bar_addr2, :bar_city, :bar_state, :bar_zip, :bar_location, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun
  validates_presence_of :bar_name, :bar_location, :bar_phone, :bar_url, :bar_addr1, :bar_city, :bar_state, :bar_zip, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun
  before_save :ensure_fields

  def set_phone_number
    self.bar_phone = number_to_phone(self.bar_phone.gsub(/[^\d]/, ""), :area_code => true)
  end

  def set_geo_location
    geo = MultiGeocoder.geocode("#{self.bar_addr1}, #{self.bar_city}, #{self.bar_state} #{self.bar_zip}").ll.split(',')
    self.bar_location = ParseGeoPoint.new :latitude => geo[0].to_f, :longitude => geo[1].to_f
  end

  def set_bar_owner(id)
    self.bar_owner_id = id
  end

  def ensure_fields
    set_phone_number
    set_geo_location
  end
end