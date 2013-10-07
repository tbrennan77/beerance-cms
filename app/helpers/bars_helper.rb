module BarsHelper
  def bar_error(message)
    message.gsub("Latitude can't be blank", "Unable to geocode address").gsub("end", "closed at time").gsub("start", "open at time")
  end

  def class_for_plan(plan)
    case plan.name
    when '12_months'
      'green'
    when '6_months'
      'in-brown'
    when '3_months'
      'orange'
    end
  end
end
