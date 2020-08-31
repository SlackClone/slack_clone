FactoryBot.define do
  factory :workspace do

    name { Faker::Name.name }

    factory :workspace_with_channels do
      channels { [association(:channel)] }
    end
  end
end