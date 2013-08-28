FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@beeranceapp.com"
  end

  factory :user, aliases: [:bar_owner] do
    username       { FactoryGirl.generate(:email) }
    password       "johnsonite"
    owner_name     'Gary Man'
    owner_phone    '123456789'
    admin          false
  end
end
