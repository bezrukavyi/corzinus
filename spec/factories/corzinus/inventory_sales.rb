FactoryGirl.define do
  factory :corzinus_inventory_sale, class: 'Corzinus::InventorySale' do
    start_stock 100
    inventory { create :corzinus_inventory }
  end

  trait :with_supply do
    supply { create :corzinus_inventory_supply }
  end
end
