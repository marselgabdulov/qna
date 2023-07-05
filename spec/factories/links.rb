FactoryBot.define do
  factory :link do
    association :linkable, factory: :question

    name { 'Google' }
    url { 'https://google.com' }
  end
end
