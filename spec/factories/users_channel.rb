FactoryBot.define do
  factory :users_channel do
    association :user
    association :channel

  end
end