FactoryGirl.define do
  factory :corzinus_order, class: 'Corzinus::Order' do
    state 'MyString'
    delivery { create :corzinus_delivery }
    credit_card { create :corzinus_credit_card }
    total_price 100.0
    person nil

    trait :multiple do
      order_items { [create(:order_item, :book_item)] }
      order_items { [create(:order_item, :slipper_item)] }
    end

    trait :with_books do
      order_items { [create(:order_item, :book_item)] }
    end

    trait :with_slippers do
      order_items { [create(:order_item, :book_item)] }
    end
  end
end
