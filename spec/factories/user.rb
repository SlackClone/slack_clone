FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
    email { Faker::Internet.unique.email}
    password { Faker::Lorem.characters(number: 6) }
  end
end