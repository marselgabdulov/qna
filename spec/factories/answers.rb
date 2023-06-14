FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question, factory: :question
  end
end
