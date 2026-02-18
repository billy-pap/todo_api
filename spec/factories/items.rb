FactoryBot.define do
  factory :item do
    content { "MyString" }
    done { false }
    todo { nil }
  end
end
