FactoryGirl.define do
  factory :corzinus_coupon, class: Corzinus::Coupon do
    code { rand(1_000_000).to_s }
    discount 25

    trait :used do
      order { create :corzinus_order }
    end
  end
end
