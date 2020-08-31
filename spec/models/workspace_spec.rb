require 'rails_helper'

RSpec.describe Workspace, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'association' do
    it { should have_many(:channels) }
  end

end
