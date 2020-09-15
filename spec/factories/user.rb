FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
  end
end