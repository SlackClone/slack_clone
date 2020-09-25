FactoryBot.define do
  factory :uploadedfile do
    file_data { "MyText" }
    user { nil }
    message { nil }
  end
end
