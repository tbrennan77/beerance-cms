require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class BarEntityTest < ActiveSupport::TestCase

  def setup    
    @bar = BarEntity.new(
        bar_owner_id: "1",
        bar_name: 'Rocky River Brewing Company',
        bar_phone: '2165551234',
        bar_url: 'http://www.google.com',
        bar_addr1: '21290 Center Ridge Road',
        bar_addr2: '',
        bar_city: 'Cleveland',
        bar_state: 'OH',
        bar_zip: '44116',
        bar_location: '',
        hours_mon: '7:00am - 10:00pm',
        hours_tues: '7:00am - 10:00pm',
        hours_wed: '7:00am - 10:00pm',
        hours_thur: '7:00am - 10:00pm',
        hours_fri: '7:00am - 10:00pm',
        hours_sat: '7:00am - 10:00pm',
        hours_sun: '7:00am - 10:00pm')
    @bar.ensure_fields
  end

  # test validations
  test "it can create a bar" do
    assert @bar.valid?
  end

  test "should not save bar without bar name" do
    @bar.bar_name = nil
    assert !@bar.valid?
  end

  test "should not save bar without a bar location" do
    @bar.bar_location = nil
    assert !@bar.valid?
  end

  test "should not save bar without a bar phone" do
    @bar.bar_phone = nil
    assert !@bar.valid?
  end

  test "should not save bar without website" do
    @bar.bar_url = nil
    assert !@bar.valid?
  end

  test "should not save bar without address 1 field" do
    @bar.bar_addr1 = nil
    assert !@bar.valid?
  end

  test "should not save bar without city" do
    @bar.bar_city = nil
    assert !@bar.valid?
  end

  test "should not save bar without state" do
    @bar.bar_state = nil
    assert !@bar.valid?
  end

  test "should not save bar without zip" do
    @bar.bar_zip = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_mon" do
    @bar.hours_mon = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_tues" do
    @bar.hours_tues = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_wed" do
    @bar.hours_wed = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_thur" do
    @bar.hours_thur = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_fri" do
    @bar.hours_fri = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_sat" do
    @bar.hours_sat = nil
    assert !@bar.valid?
  end

  test "should not save bar without hours_sun" do
    @bar.hours_sun = nil
    assert !@bar.valid?
  end

  # test functional methods
  test "set geo location should set geo location to bar's geo location" do
    @bar.save
    assert_match /-|\d{2}\.\d+/, @bar.bar_location.latitude.to_s
    assert_match /-|\d{2}\.\d+/, @bar.bar_location.longitude.to_s
  end
end