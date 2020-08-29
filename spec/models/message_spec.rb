require 'rails_helper'

RSpec.describe Message, type: :model do
  # 確認所有欄位的 type 是否正確
  it "is valid with valid attributes" do
    message = Message.new
    workspace = Workspace.create(name: "W_1")
    channel = Channel.create(name: "C_1", public: true, members: 1, workspace_id: workspace.id)
    message.channel_id = channel.id
    message.content = "Anything"
    message.deleted_at = DateTime.now
    expect(message).to be_valid
  end

  # 確認 content 這個欄位為「必填」
  it "is not valid without a content" do
    message = Message.new(content: nil)
    expect(message).not_to be_valid
  end

  # create 一個 channel、一個 message，測試 message.channel 跟 channel 同一個
  it "belongs_to channel" do
    workspace = Workspace.create(name: "W_1")
    channel = Channel.create(name: "C_1", public: true, members: 1, workspace_id: workspace.id)
    message = Message.create(content: "anything", channel_id: channel.id)
    expect(message.channel).to eq(channel)
  end
end
