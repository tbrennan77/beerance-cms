FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@beeranceapp.com"
  end

  factory :user, aliases: [:bar_owner] do
    email          { FactoryGirl.generate(:email) }
    password       "johnsonite"
    name           'Gary Man'
    phone          '123456789'
    admin          false
  end
end
