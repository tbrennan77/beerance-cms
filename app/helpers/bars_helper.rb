module BarsHelper
  def bar_error(message)
    message.gsub("Latitude can't be blank", "Unable to geocode address").gsub("end", "closed at time").gsub("start", "open at time")
  end
end
