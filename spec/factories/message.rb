FactoryBot.define do
  factory :message do
    association :channel
    content { Faker::Lorem.sentence }
  end
end