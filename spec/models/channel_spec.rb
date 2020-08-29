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
  it "is not valid with same name" do
    channel1 = Channel.new
    channel1.name = "CN_name"
    channel1.save
    channel2 = Channel.new
    channel2.name = "CN_name"
    expect(channel2).not_to be_valid
  end

  # 確認 public 這個欄位為「必填」
  it "is not valid without a public" do
    channel = Channel.new(public: nil)
    expect(channel).not_to be_valid
  end

  # 確認 members 這個欄位「預設值為1」
  it "is 1 in memebers default value" do
    channel = Channel.new
    expect(channel.members).to eq(1)
  end

  # create 一個 workspace、一個 channel，測試 workspace.channels 是否包含 channel
  it "belongs_to workspace" do
    workspace = Workspace.create(name: "W_1")
    channel = Channel.create(name: "C_1", public: true, members: 1, workspace_id: workspace.id)
    expect(channel.workspace).to eq(workspace)
  end

end
