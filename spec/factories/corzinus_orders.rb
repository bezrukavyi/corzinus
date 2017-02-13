FactoryGirl.define do
  factory :corzinus_order, class: 'Corzinus::Order' do
    state 'MyString'
    delivery { create :corzinus_delivery }
    credit_card { create :corzinus_credit_card }
    total_price 100.0
    person nil

    trait :with_items do
      order_items { [create(:corzinus_order_item, quantity: 1)] }
    end
  end
end
