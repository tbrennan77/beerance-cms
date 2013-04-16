require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class BarSpecialsTest < ActiveSupport::TestCase

  def setup
    @tomorrow  = ParseDate.new(iso: Time.new(Date.tomorrow.year, Date.tomorrow.month, Date.tomorrow.day, 9).utc.iso8601)
    @yesterday = ParseDate.new(iso: Time.new(Date.yesterday.year, Date.yesterday.month, Date.yesterday.day, 9).utc.iso8601)
    @bar = BarEntity.first
    @bar_special = BarSpecials.new(
      bar_id: @bar.id,
      special_description: "special description",
      sale_price: 3.99,
      beer_color: 1,
      beer_size: 12)
    @bar_special.ensure_fields
  end

  # test validations
  test "it can create a special" do    
    assert @bar_special.valid?
  end
  
  test "should not save special without bar id" do
    @bar_special.bar_id = nil
    assert !@bar_special.valid?
  end

  test "should not save special without description" do
    @bar_special.special_description = nil
    assert !@bar_special.valid?
  end

  test "should not save special without sale price" do
    @bar_special.sale_price = nil
    assert !@bar_special.valid?
  end

  test "should not save special without beer color" do
    @bar_special.beer_color = nil
    assert !@bar_special.valid?
  end

  test "should not save special without beer size" do
    @bar_special.beer_size = nil
    assert !@bar_special.valid?
  end

  # test numericalities
  test "should not save special if beer color is not a number" do
    @bar_special.beer_color = "foo"
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
    bar_special = BarSpecials.create(
      bar_id: @bar.id,
      special_description: "special description",
      sale_price: 3.99,
      beer_color: 1,
      beer_size: 12)
    bar_special.end_special
    bar_special.save
    assert_equal @yesterday, bar_special.expiration_date
  end

  test "reactivate special sets expiration_date to tomorrow" do
    bar_special = BarSpecials.create(
      bar_id: @bar.id,
      special_description: "special description",
      sale_price: 3.99,
      beer_color: 1,
      beer_size: 12)
    bar_special.reactivate_special
    bar_special.save
    assert_equal @tomorrow, bar_special.expiration_date
  end

  test "set expiration_date set expiration_date to tomorrow" do    
    bar_special = BarSpecials.create(
      bar_id: @bar.id,
      special_description: "special description",
      sale_price: 3.99,
      beer_color: 1,
      beer_size: 12)
    assert_equal @tomorrow, bar_special.expiration_date
  end
end