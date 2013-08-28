FactoryGirl.define do
  sequence :email do |n|
    "test#{n}"
  end

  factory :user, aliases: [:bar_owner] do
    email          { FactoryGirl.generate(:email) }
    password       "johnsonite"        
    admin          false
  end
end
