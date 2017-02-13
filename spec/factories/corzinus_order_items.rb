FactoryGirl.define do
  factory :corzinus_order_item, class: 'Corzinus::OrderItem' do
    quantity 1
    order { create :corzinus_order }
  end
end
