FactoryGirl.define do
  factory :corzinus_inventory, class: 'Corzinus::Inventory' do
    count 100
    productable { create :typical_product }
  end
end
