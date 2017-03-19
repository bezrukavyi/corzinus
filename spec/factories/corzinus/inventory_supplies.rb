FactoryGirl.define do
  factory :corzinus_inventory_supply, class: 'Corzinus::InventorySupply' do
    size 1
    arrived_at DateTime.now + 4.days
  end

  trait :with_sale do
    sale { create :corzinus_inventory_sale }
  end
end
