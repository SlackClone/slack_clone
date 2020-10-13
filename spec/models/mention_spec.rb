require 'rails_helper'

RSpec.describe Mention, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'association' do
    it { should belong_to(:mentionable) }
    it { should belong_to(:message) }
    it { should belong_to(:user) }
  end
end
