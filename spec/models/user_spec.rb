require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nickname) }
  end

  describe 'association' do
    it { should have_many(:users_workspaces) }
    it { should have_many(:workspaces) }
    it { should have_many(:users_channels) }
    it { should have_many(:channels) }
    it { should have_many(:messages) }
    it { should have_many(:invitations) }
    it { should have_many(:users_directmsgs) }
    it { should have_many(:directmsgs) }
    it { should have_many(:mentions) }
  end

end
