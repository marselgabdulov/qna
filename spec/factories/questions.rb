FactoryBot.define do
  factory :question do
    association :user, factory: :user

    title { "Question Title" }
    body { "Question Body" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new('spec/support/assets/default.jpg', 'image/jpg')] }
    end

    trait :with_answer do
      after(:create) do |question|
        create(:answer, question_id: question.id)
      end
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end
  end
end
