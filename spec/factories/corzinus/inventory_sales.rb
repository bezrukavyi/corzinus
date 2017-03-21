FactoryGirl.define do
  factory :corzinus_inventory_sale, class: 'Corzinus::InventorySale' do
    start_stock 100
    inventory { create :corzinus_inventory }
  end

  trait :with_supply do
    after(:create) do |sale|
      sale.supply = create :corzinus_inventory_supply, sale: sale
    end
  end
end
