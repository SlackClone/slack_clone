FactoryBot.define do
  factory :message do
    association :messageable, factory: :channel
    association :user
    content { Faker::Lorem.sentence }
  end
end