class Subscription < ParseResource::Base
  fields :user_id, :subscription_plan_id, :expiration_date

  validates_presence_of :user_id, :subscription_plan_id  

  before_save :set_expiration

  def plan
    SubscriptionPlan.find subscription_plan_id
  end

  def set_expiration
    end_date = Date.today.advance months: plan.length_in_months
    self.expiration_date = DateTime.new(end_date.year, end_date.month, end_date.day)
  end

  def days_remaining
    (Date.new(expiration_date.year, expiration_date.month, expiration_date.day)-Date.today).to_i
  end

  def subscription_plan
    SubscriptionPlan.find subscription_plan_id
  end
end