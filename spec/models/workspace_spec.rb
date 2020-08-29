require 'rails_helper'

RSpec.describe Workspace, type: :model do
  # 確認所有欄位的 type 是否正確 ex. name 是string
  it "is valid with valid attributes" do
    workspace = Workspace.new
    workspace.name = "Anything"
    workspace.deleted_at = DateTime.now
    expect(workspace).to be_valid
  end

  # 確認 name 這個欄位為「必填」
  it "is not valid without a name" do
    workspace = Workspace.new(name: nil)
    expect(workspace).not_to be_valid
  end

  # 確認 name 必須要是「唯一值」
  it "is not valid with same name" do
    workspace1 = Workspace.new
    workspace1.name = "WS_name"
    workspace1.save
    workspace2 = Workspace.new
    workspace2.name = "WS_name"
    expect(workspace2).not_to be_valid
  end

  # 確認 created_at 這個欄位為「必填」
  it "is not valid without a created_at" do
    workspace = Workspace.new(created_at: nil)
    expect(workspace).not_to be_valid
  end
end
