FactoryGirl.define do
  factory :corzinus_country, class: Corzinus::Country do
    name { FFaker::Address.country }
    code '380'
  end
end
