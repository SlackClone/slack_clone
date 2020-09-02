require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'association' do
    it { should belong_to(:channel) }
  end
end
