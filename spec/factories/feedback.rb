FactoryGirl.define do
  factory :feedback do
    user
    category    'Design'
    comment     'My Comment'
  end
end
