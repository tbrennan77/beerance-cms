class Subscription < ParseResource::Base
  fields :user_id, :subscription_plan_id, :expiration_date

  validates_presence_of :user_id, :subscription_plan_id
  before_create :set_expiration

  def plan
    SubscriptionPlan.find subscription_plan_id
  end

  def set_expiration
    self.expiration_date = ParseDate.new(iso: DateTime.new(Date.today.advance(months: plan.length_in_months).year, Date.today.advance(months: plan.length_in_months).month, Date.today.advance(months: plan.length_in_months).day).utc.iso8601)    
  end

  def day_remaining
    expiration_date-Date.today
  end
end