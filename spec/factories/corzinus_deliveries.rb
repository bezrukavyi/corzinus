FactoryGirl.define do
  factory :corzinus_delivery, class: 'Corzinus::Delivery' do
    name { "#{FFaker::Address.country} Standart Post" }
    price 9.99
    min_days 5
    max_days 10
    country { create :corzinus_country }

    trait :invalid do
      name nil
    end
  end
end
