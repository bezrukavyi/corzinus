FactoryGirl.define do
  factory :typical_user do
    first_name 'Ivan'
    last_name 'Ivan'
    email { FFaker::Internet.email }
  end
end
