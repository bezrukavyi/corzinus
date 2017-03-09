FactoryGirl.define do
  factory :corzinus_order_item, class: Corzinus::OrderItem do
    quantity 2
    productable { create :typical_product }
    order { create :corzinus_order }
  end
end
