module BarEntitiesHelper
  def selected_time(time)
    time ||= ' - '
    times = time.split(' - ')
    {open: times[0], close: times[1]}
  end

  def bar_error(message)
    message.gsub("Bar location can't be blank", "Unable to geocode address")
    message.gsub("Bar addr1 can't be blank", "Bar address can't be blank")
  end
end
