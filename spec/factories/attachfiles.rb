FactoryBot.define do
  factory :attachfile do
    association :message
    document { Rack::Test::UploadedFile.new('spec/factories/test.jpg', 'image/jpg') }
  end
end
