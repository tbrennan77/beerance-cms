class BarEntity < ParseResource::Base
  attr_accessor :stripe_card_token
  fields :bar_owner_id,
        :bar_name,
        :bar_phone,
        :bar_url,
        :bar_addr1,
        :bar_addr2,
        :bar_city,
        :bar_state,
        :bar_zip,
        :bar_location,
        :hours_mon,
        :hours_tues,
        :hours_wed,
        :hours_thur,
        :hours_fri,
        :hours_sat,
        :hours_sun,
        :mon_start,
        :mon_end,
        :tue_start,
        :tue_end,
        :wed_start,
        :wed_end,
        :thu_start,
        :thu_end,
        :fri_start,
        :fri_end,
        :sat_start,
        :sat_end,
        :sun_start,
        :sun_end

  validates_presence_of :bar_name, :bar_location, :bar_phone, :bar_url, :bar_addr1, :bar_city, :bar_state, :bar_zip, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun
  before_save :ensure_fields

  def set_phone_number
    self.bar_phone = self.bar_phone.gsub(/[^\d]/, "")
  end

  def set_url
    self.bar_url = "http://#{self.bar_url.gsub(/(https:\/\/|http:\/\/)/,'')}"
  end

  def set_geo_location
    geo = Geocoder.search("#{self.bar_addr1}, #{self.bar_city}, #{self.bar_state} #{self.bar_zip}")
    lat = geo.first.data['geometry']['location']['lat']
    lng = geo.first.data['geometry']['location']['lng']
    self.bar_location = ParseGeoPoint.new :latitude => lat, :longitude => lng    
  end

  def update_specials
    specials = BarSpecials.where(bar_id: self.id)
    if specials
      specials.each do |s|
        s.bar_location = self.bar_location
        s.save
      end
    end
  end

  def bar_specials
    BarSpecials.where(bar_id: self.id)
  end

  def user
    User.find self.bar_owner_id
  end

  def set_bar_owner(id)
    self.bar_owner_id = id
  end

  def ensure_fields
    set_phone_number
    set_url
    set_geo_location
    update_specials
  end
end