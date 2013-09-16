FactoryGirl.define do
  factory :bar do
    user
    subscription_plan
    name            'Rocky River Brewing Company'
    phone           '2165551234'
    url             'http://www.google.com'
    address         '21290 Center Ridge Road'
    city            'Cleveland'
    state           'OH'
    zip             '44116'
    latitude        41.462172
    longitude       -81.856004
    sunday_start    '7:00am'
    sunday_end      '10:00pm'
    monday_start    '7:00am'
    monday_end      '10:00pm'
    tuesday_start   '7:00am'
    tuesday_end     '10:00pm'
    wednesday_start '7:00am'
    wednesday_end   '10:00pm'
    thursday_start  '7:00am'
    thursday_end    '10:00pm'
    friday_start    '7:00am'
    friday_end      '10:00pm'
    saturday_start  '7:00am'
    saturday_end    '10:00pm'
  end
end
