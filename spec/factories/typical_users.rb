FactoryGirl.define do
  factory :typical_user do
    first_name 'Ivan'
    last_name 'Ivan'
    email { FFaker::Internet.email }
  end

  trait :with_billing do
    after :create do |user|
      create(:corzinus_address, :billing, addressable: user)
    end
  end
end
