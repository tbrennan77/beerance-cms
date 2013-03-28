class BarEntity < ParseUser
  fields :bar_owner_id, :bar_name, :bar_phone, :bar_url, :bar_addr1, :bar_addr2, :bar_city, :bar_state, :bar_zip, :bar_location, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun
  validates_presence_of :bar_name, :bar_phone, :bar_url, :bar_addr1, :bar_city, :bar_state, :bar_zip, :bar_location, :hours_mon, :hours_tues, :hours_wed, :hours_thur, :hours_fri, :hours_sat, :hours_sun
end