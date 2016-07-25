FactoryGirl.define do

  factory :user do
    name Faker::Name.name
    sequence(:email){|n| "user#{n}@blocipedia.com" }
    password "123456"
    password_confirmation "123456"
    confirmed_at Date.today
  end
end
