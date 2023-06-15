FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
