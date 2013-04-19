require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test "it has a subscription plan" do
    subscription = Subscription.new user_id: "1", expiration_date: Date.today
    assert !subscription.valid?
  end

  test "it has a user id" do
    subscription = Subscription.new expiration_date: Date.today, subscription_plan_id: "1"
    assert !subscription.valid?
  end

  test "is sets the expiration date on create" do
    subscription_plan = SubscriptionPlan.first
    subscription = Subscription.create user_id: "1", subscription_plan_id: subscription_plan.id
    expected_time = Time.new(Date.today.advance(months: subscription_plan.length_in_months).year, Date.today.advance(months: subscription_plan.length_in_months).month, Date.today.advance(months: subscription_plan.length_in_months).day).utc
    assert_equal expected_time, subscription.expiration_date
  end
end