FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://google.com' }
  end

  trait :for_question do
    association :linkable, factory: :question
  end

  trait :for_answer do
    association :linkable, factory: :answer
  end
end
