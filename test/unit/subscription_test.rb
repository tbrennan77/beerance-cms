require 'test_helper'
 
class SubscriptionTest < ActiveSupport::TestCase
  test "it has a subscription plan" do
    subscription = Subscription.new user_id: 1, expiration_date: Date.today
    assert !subscription.valid?
  end

  test "it has a user id" do
    subscription = Subscription.new expiration_date: Date.today, subscription_plan_id: 1
    assert !subscription.valid?
  end

  test "it has an expiration_date" do
    subscription = Subscription.new expiration_date: Date.today, user_id: 1
    assert !subscription.valid?
  end  
end