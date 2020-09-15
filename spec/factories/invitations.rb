FactoryBot.define do
  factory :invitation do
    association :user
    association :workspace
    receiver_email { Faker::Internet.email }
    invitation_token { Faker::Lorem.characters(number: 20) }
    accept_at { Faker::Date.in_date_period }
  end
end
