FactoryBot.define do
  factory :answer do
    association :user, factory: :user

    body { "Answer Body" }

    trait :invalid do
      body { nil }
    end
  end
end
