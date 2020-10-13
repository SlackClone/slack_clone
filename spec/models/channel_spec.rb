require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:public) }
    it "is valid if public default value is true" do
      channel = create(:channel)
      expect(channel.public).to eq(true)
    end
    subject { FactoryBot.create(:channel) }
    it { should validate_uniqueness_of(:name).scoped_to(:workspace_id) }
  end

  describe 'association' do
    it { should belong_to(:workspace) }
    it { should have_many(:messages) }
    it { should have_many(:mentions) }
  end

end
