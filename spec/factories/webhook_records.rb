FactoryBot.define do
  factory :webhook_record do
    repo_name { "MyString" }
    secret { "MyString" }
    payload_url { "MyString" }
    user_id { nil }
    channel_id { nil }
  end
end
