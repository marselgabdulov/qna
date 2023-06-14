FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :answer, factory: :answer
  end
end
