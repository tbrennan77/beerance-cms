require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test "it has a subscription plan" do
    subscription = Subscription.new user_id: "1", expiration_date: Date.today, subscription_plan_id: nil
    assert !subscription.valid?
  end

  test "it has a user id" do
    subscription = Subscription.new expiration_date: Date.today, subscription_plan_id: "1", user_id: nil
    assert !subscription.valid?
  end

  test "is sets the expiration date on create" do
    subscription_plan = SubscriptionPlan.first
    subscription = Subscription.create user_id: "1", subscription_plan_id: subscription_plan.id
    
    end_date = Date.today.advance months: subscription_plan.length_in_months
    expected_time = Time.new(end_date.year, end_date.month, end_date.day).utc
    
    assert_equal expected_time, subscription.expiration_date.utc
  end

end