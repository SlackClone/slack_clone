FactoryBot.define do
  factory :profile do
    full_name { "MyString" }
    avatar_data { "MyText" }
    phone_number { "MyString" }
    user { nil }
  end
end
