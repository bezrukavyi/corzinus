FactoryGirl.define do
  factory :corzinus_inventory, class: 'Corzinus::Inventory' do
    count 100
    productable { create :typical_product }
  end

  trait :with_sales do
    sales { [create(:corzinus_inventory_sale)] }
  end
end
