class Subscription
  attr_reader :json

  def initialize(json)
    @json=json
  end

  def end_date
    Time.at json.current_period_end
  end

  def start_date
    Time.at json.current_period_start
  end

  def name
    json.plan.name
  end

  def nice_name
    case name
    when '12_months'
      "Gold"
    when '6_months'
      "Silver"
    when '3_months'
      "Bronze"
    end
  end

  def amount
    json.plan.amount/100
  end

  def days_remaining
    (end_date.to_date-Date.today).to_i
  end
end