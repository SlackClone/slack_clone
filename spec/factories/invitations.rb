FactoryBot.define do
  factory :invitation do
    receiver_email { "MyString" }
    invitation_token { "MyString" }
    user_id { nil }
    workspace_id { nil }
    accept_at { "2020-09-10 10:35:46" }
  end
end
