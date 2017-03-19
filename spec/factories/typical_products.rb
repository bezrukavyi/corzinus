FactoryGirl.define do
  factory :typical_product, class: TypicalProduct do
    title { FFaker::Book.title }
    price 100.00
    count 200

    trait :invalid do
      title nil
    end

    trait :with_inventory do
      inventory { create :corzinus_inventory }
    end
  end
end
