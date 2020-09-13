require 'rails_helper'

RSpec.describe UsersDirectmsg, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:directmsg) }
  end
end
