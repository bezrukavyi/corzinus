FactoryGirl.define do
  factory :corzinus_coupon, class: 'Corzinus::Coupon' do
    discount 1
    code { "MyCoupon_#{rand(1_000_000)}" }
    order { create :corzinus_order }
  end
end
