require 'rails_helper'

RSpec.describe UsersWorkspace, type: :model do

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:workspace) }
  end
end
