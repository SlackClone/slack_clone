FactoryBot.define do
  factory :channel do
    workspace

    name { 'aa' }
    public { true }
    members { 1 }
  end
end