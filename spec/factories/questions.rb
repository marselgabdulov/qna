FactoryBot.define do
  factory :question do
    association :user, factory: :user

    title { "Question Title" }
    body { "Question Body" }

    trait :invalid do
      title { nil }
    end

    trait :with_answer do
      after(:create) do |question|
        create(:answer, question_id: question.id)
      end
    end
  end
end
