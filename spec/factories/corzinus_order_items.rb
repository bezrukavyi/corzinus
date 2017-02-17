FactoryGirl.define do
  factory :corzinus_order_item, class: 'Corzinus::OrderItem' do
    quantity 2
    order { create :corzinus_order }

    trait :book_item do
      productable { create :corzinus_book }
    end

    trait :slipper_item do
      productable { create :corzinus_slipper }
    end
  end
end
