FactoryGirl.define do
  factory :corzinus_inventory, class: 'Corzinus::Inventory' do
    count 100
    productable { create :typical_product }
  end

  trait :with_sales do
    after(:create) do |inventory|
      inventory.sales << create(:corzinus_inventory_sale, inventory: inventory)
    end
  end

  trait :with_supplies do
    after(:create) do |inventory|
      inventory.sales = create_list :corzinus_inventory_sale, 3, :with_supply,
                                    inventory: inventory
    end
  end
end
