FactoryGirl.define do
  factory :bar_entity do
    user
    subscription_plan
    bar_name       'Rocky River Brewing Company'
    bar_phone      '2165551234'
    bar_url        'http://www.google.com'
    bar_addr1      '21290 Center Ridge Road'
    bar_addr2      ''
    bar_city       'Cleveland'
    bar_state      'OH'
    bar_zip        '44116'
    bar_location   ParseGeoPoint.new(latitude: 41.462172, longitude: -81.856004)
    hours_mon      '7:00am - 10:00pm'
    hours_tues     '7:00am - 10:00pm'
    hours_wed      '7:00am - 10:00pm'
    hours_thur     '7:00am - 10:00pm'
    hours_fri      '7:00am - 10:00pm'
    hours_sat      '7:00am - 10:00pm'
    hours_sun      '7:00am - 10:00pm'
  end
end
