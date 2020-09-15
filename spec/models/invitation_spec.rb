require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:receiver_email) }
    it { should validate_presence_of(:invitation_token) }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:workspace) }
  end
end
