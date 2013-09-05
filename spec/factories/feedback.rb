FactoryGirl.define do
  factory :feedback do
    name        'Jon Doe'
    email       'test@email.com'
    phone       '123456789'
    category    'Test category'
    comment     'My Comment'
  end
end
