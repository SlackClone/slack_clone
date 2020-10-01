require 'rails_helper'

RSpec.describe MessageFile, type: :model do
  describe 'association' do
    it { should belong_to(:message) }
    it { should belong_to(:attachfile) }
  end
end
