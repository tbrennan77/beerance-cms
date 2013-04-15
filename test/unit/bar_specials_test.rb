require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class BarSpecialsTest < ActiveSupport::TestCase

  def setup
    @bar = BarEntity.first
  end

  # test validations
  test "it has a bar id" do
    bar_special = BarSpecials.new special_description: "special description", sale_price: 3.99, beer_color: 1
    assert !bar_special.valid?
  end

  test "it has a special description" do
    bar_special = BarSpecials.new bar_id: @bar.id, sale_price: 3.99, beer_color: 1
    assert !bar_special.valid?
  end

  test "it has a sale price" do
    bar_special = BarSpecials.new bar_id: @bar.id, special_description: "special_description", beer_color: 1
    assert !bar_special.valid?
  end

  test "it has a beer color" do
    bar_special = BarSpecials.new bar_id: @bar.id, sale_price: 3.99, special_description: 'special_description'
    assert !bar_special.valid?
  end

  # test numericalities
  test "fails if beer price is not a number" do
    bar_special = BarSpecials.new bar_id: @bar.id, sale_price: "foo", special_description: 'special_description', beer_color: "foo"
    bar_special.ensure_fields
    assert !bar_special.valid?
    #subscription_plan = SubscriptionPlan.first
    #subscription = Subscription.create user_id: "1", subscription_plan_id: subscription_plan.id
    #assert_equal DateTime.tomorrow, bar_special.expiration_date
  end
end