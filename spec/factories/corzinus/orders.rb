FactoryGirl.define do
  factory :corzinus_order, class: Corzinus::Order do
    person nil

    trait :with_products do
      order_items { create_list(:corzinus_order_item, 2) }
    end

    trait :with_addresses do
      after(:create) do |order|
        order.billing = create :corzinus_address_order, :billing
        order.shipping = create :corzinus_address_order, :shipping
      end
    end

    trait :with_delivery do
      delivery { create :corzinus_delivery }
    end

    trait :with_credit_card do
      credit_card { create :corzinus_credit_card }
    end

    trait :full_package do
      with_products
      with_addresses
      with_delivery
      with_credit_card
    end
  end
end
