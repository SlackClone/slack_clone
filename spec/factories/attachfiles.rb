FactoryBot.define do
  factory :attachfile do
    association :message
    document_data { "MyText" }
  end
end
