FactoryBot.define do
  factory :users_workspaces do
    association :user
    association :workspace
    role { Faker::Job.position }
  end
end