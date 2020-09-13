FactoryBot.define do
  factory :directmsg do
    association :workspace
    name { Faker::Name.name }
    deleted_at { Faker::Date.in_date_period }
  end
end
