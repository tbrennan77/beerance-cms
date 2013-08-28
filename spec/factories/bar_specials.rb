FactoryGirl.define do
  factory :bar_specials do
    bar_entity
    special_description  "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
  end
end
