FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  after(:create) { |user| user.confirm }

  trait :unconfirmed do
    confirmed { false }
  end
end
