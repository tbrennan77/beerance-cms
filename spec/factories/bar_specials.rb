FactoryGirl.define do
  factory :bar_specials do
    bar_entity
    special_description  "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
  end

  factory :active_bar_specials, class: BarSpecials do
    bar_entity
    special_description  "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
    expiration_date      Time.now.advance(days: 1)
  end

  factory :inactive_bar_specials, class: BarSpecials do
    bar_entity
    special_description  "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
    expiration_date      Time.now.advance(days: -1)
  end
end
