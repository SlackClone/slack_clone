require 'rails_helper'

RSpec.describe Directmsg, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'association' do
    it { should have_many(:users_directmsgs) }
    it { should have_many(:users) }
    it { should have_many(:messages) }
    it { should belong_to(:workspace) }
  end
end
