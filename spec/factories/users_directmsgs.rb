FactoryBot.define do
  factory :users_directmsg do
    association :user
    association :directmsg
  end
end
