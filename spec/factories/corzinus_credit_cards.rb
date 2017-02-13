FactoryGirl.define do
  factory :corzinus_credit_card, class: 'Corzinus::CreditCard' do
    name 'Ivan Ivan'
    cvv '123'
    month_year '12/17'
    number '5274576394259961'
    person nil

    trait :invalid do
      name nil
    end
  end
end
