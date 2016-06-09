FactoryGirl.define do
  pw = RandomData.random_sentence

  factory :user do
    name RandomData.random_name
    sequence(:email){|n| "user#{n}@blocipedia.com" }
    password pw
    password_confirmation pw
  end
end
