FactoryBot.define do
  factory :answer do
    user
    question

    body { "Answer Body" }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new('spec/support/assets/default.jpg', 'image/jpg')] }
    end
  end
end
