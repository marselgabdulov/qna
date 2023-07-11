FactoryBot.define do
  factory :comment do
    association :user, factory: :user

    body { 'Comment Body' }

    trait :invalid do
      body { nil }
    end
  end
end
