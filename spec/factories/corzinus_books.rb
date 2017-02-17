FactoryGirl.define do
  factory :corzinus_book, class: Book do
    title { FFaker::Book.title }
    price 100.00
    count 200

    trait :invalid do
      title nil
    end
  end
end
