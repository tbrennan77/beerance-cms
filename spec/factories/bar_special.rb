FactoryGirl.define do
  factory :bar_special do
    bar
    description          "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
  end

  factory :active_bar_special, class: BarSpecial do
    bar
    description          "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
    expiration_date      Time.now.advance(days: 1)
  end

  factory :inactive_bar_special, class: BarSpecial do
    bar
    description          "special description"
    sale_price           3.99
    beer_color           1
    beer_size            12
    expiration_date      Time.now.advance(days: -1)
  end
end
