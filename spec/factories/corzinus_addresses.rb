FactoryGirl.define do
  factory :corzinus_address, class: Corzinus::Address do
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    name FFaker::Address.street_name
    city 'Dnepr'
    zip 49_000
    phone '+380632863823'
    address_type 1
    country { create :corzinus_country }
  end

  trait :shipping do
    address_type :shipping
  end

  trait :billing do
    address_type :billing
  end

  trait :invalid do
    first_name nil
    address_type :billing
  end
end
