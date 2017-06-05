FactoryGirl.define do
  factory :corzinus_inventory_analysis, class: 'Corzinus::InventoryAnalysis' do
    inventory_data ""
    demand_data ""
    price_data ""
    delivery_cost 1.5
    warehous_cost 1.5
    reserve 1
  end
end
