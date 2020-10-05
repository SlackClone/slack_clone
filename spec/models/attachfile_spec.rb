require 'rails_helper'

RSpec.describe Attachfile, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:document_data) }
  end

  describe 'association' do
    it { should have_many(:messages) }
  end
end
