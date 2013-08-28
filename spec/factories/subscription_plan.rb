FactoryGirl.define do
  factory :subscription_plan do
    name                '6_months'
    amount              5700
    friendly_name       'Plan 2'
    image               'amber.png'
    length_in_months    6    
  end
end
