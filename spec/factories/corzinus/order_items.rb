FactoryGirl.define do
  factory :corzinus_order_item, class: Corzinus::OrderItem do
    quantity 2
    order { create :corzinus_order }

    trait :with_product do
      productable { create :typical_product }
    end
  end
end
