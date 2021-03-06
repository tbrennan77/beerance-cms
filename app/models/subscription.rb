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

  def canceled?
    if json.canceled_at.blank?
      false
    else
      true
    end
  end

  def canceled_at
    Time.at(json.canceled_at)
  end

  def days_remaining
    (end_date.to_date-Date.today).to_i
  end

  def status
    json.status
  end

  def active?
    if self.json
      (status == "active" || status == "trialing") ? true : false
    else
      false
    end
  end
end
