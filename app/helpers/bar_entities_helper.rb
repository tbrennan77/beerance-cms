module BarEntitiesHelper
  def selected_time(time)
    time ||= ' - '
    times = time.split(' - ')
    {open: times[0], close: times[1]}
  end
end
