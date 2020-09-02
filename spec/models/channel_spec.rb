require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:public) }
    it "is valid if public default value is true" do
      channel = create(:channel)
      # expect(channel.public).to eq(true)
      channel.public.should == true
    end
    it "is valid if name is unique with workspace_id" do
      channel1 = create(:channel)
      channel2 = build(:channel)
      expect(channel2).to validate_uniqueness_of(:name).scoped_to(:workspace_id)
    end
  end


  describe 'association' do
    it { should belong_to(:workspace) }
    it { should have_many(:messages) }
  end

end
