FactoryBot.define do
  factory :authorization do
    user factory: :user
    provider { "MyProvider" }
    uid { "MyUid" }
  end
end
