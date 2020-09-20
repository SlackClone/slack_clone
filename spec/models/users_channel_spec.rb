require 'rails_helper'

RSpec.describe UsersChannel, type: :model do

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
  end

end
