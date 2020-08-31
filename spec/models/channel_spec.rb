require 'rails_helper'

RSpec.describe Channel, type: :model do
  # 確認所有欄位的 type 是否正確
  it "is valid with valid attributes" do
    channel = Channel.new
    workspace = Workspace.create(name: "W_1")
    channel.name = "Anything"
    channel.topic = "Anything"
    channel.public = true
    channel.description = "Anything"
    channel.members = 1
    channel.workspace_id = workspace.id
    channel.deleted_at = DateTime.now
    expect(channel).to be_valid
  end

  # 確認 name 這個欄位為「必填」
  it "is not valid without a name" do
    channel = Channel.new(name: nil)
    expect(channel).not_to be_valid
  end

  # 確認 name 必須要是「唯一值」
  describe "is not valid with same name" do
    # workspace = Workspace.create(name: "W_1")
    # channel1 = Channel.create(name: "name", public: true, members: 1, workspace_id: workspace.id)
    # channel2 = Channel.create(name: "name", public: true, members: 1, workspace_id: workspace.id)
    # expect(channel2).not_to be_valid

    let!(:channel_1) { create(:channel) }
    subject { build(:channel) }
    
    it { should validate_uniqueness_of(:name) }
  end

  # 確認 public 這個欄位為「必填」
  it "is not valid without a public" do
    channel = Channel.new(public: nil)
    expect(channel).not_to be_valid
  end

  # 確認 members 這個欄位為「必填」
  it "is not valid without a members" do
    channel = Channel.new(members: nil)
    expect(channel).not_to be_valid
  end

  # create 一個 workspace、一個 channel，測試 channel.workspace 跟 workspace 同一個
  it "belongs_to workspace" do
    workspace = Workspace.create(name: "W_1")
    channel = Channel.create(name: "C_1", public: true, members: 1, workspace_id: workspace.id)
    expect(channel.workspace).to eq(workspace)
  end

  # create 一個 workspace、二個 channel，測試 workspace.channels 是否包含兩個 channel
  it "has_many messages" do
    workspace = Workspace.create(name: "W_1")
    channel = Channel.create(name: "C_1", public: true, members: 1, workspace_id: workspace.id)
    message1 = Message.create(content: "anything", channel_id: channel.id)
    message2 = Message.create(content: "anything", channel_id: channel.id)
    expect(channel.messages).to include(message1, message2)
  end

end
