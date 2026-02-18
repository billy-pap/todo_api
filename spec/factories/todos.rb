FactoryBot.define do
  factory :todo do
    title { "MyString" }
    description { "MyText" }
    user { nil }
  end
end
