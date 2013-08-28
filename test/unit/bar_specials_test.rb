require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class BarSpecialsTest < ActiveSupport::TestCase
  def setup
    @tomorrow  = DateTime.now.tomorrow.beginning_of_day.advance(hours: 9).to_time_in_current_zone
    @yesterday = DateTime.now.yesterday.beginning_of_day.advance(hours: 9).to_time_in_current_zone
    @bar = BarEntity.first
    @bar_special = BarSpecials.new(
      bar_id: @bar.id,
      special_description: "special description",
      sale_price: 3.99,
      beer_color: 1,
      beer_size: 12)    
  end

 

  # test numericalities
  test "should not save special if beer color is not a number" do
    @bar_special.beer_color = "foo"
    assert !@bar_special.valid?
  end

  test "should not save special if beer color is greater than 3" do
    @bar_special.beer_color = 4
    assert !@bar_special.valid?
  end

  test "should not save special if beer price is not a number" do
    @bar_special.sale_price = "foo"
    assert !@bar_special.valid?
  end

  test "should not save special if beer size is not a number" do
    @bar_special.beer_size = "foo"
    assert !@bar_special.valid?
  end

  # test functional methods
  test "set geo location should set geo location to bar's geo location" do
    @bar_special.save
    assert_equal @bar.bar_location.latitude, @bar_special.bar_location.latitude
    assert_equal @bar.bar_location.longitude, @bar_special.bar_location.longitude
  end

  test "set bar name should set bar name to bar's name" do
    @bar_special.set_bar_name
    assert_equal @bar.bar_name, @bar_special.bar_name
  end

  test "end special sets expiration_date to yesterday" do
    @bar_special.end_special
    @bar_special.save
    assert_equal @yesterday, @bar_special.expiration_date
  end

  test "reactivate special sets expiration_date to tomorrow" do
    @bar_special.reactivate_special
    @bar_special.save
    assert_equal @tomorrow, @bar_special.expiration_date
  end

  test "set expiration_date set expiration_date to tomorrow" do
    @bar_special.save
    assert_equal @tomorrow, @bar_special.expiration_date
  end
end
