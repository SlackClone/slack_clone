FactoryBot.define do
  factory :channel do
    association :workspace
    name { Faker::Team.name }
    public { true }
  end
end