class DraftsController < ApplicationController
  before_action :find_workspace
  def show
    @channels = @workspace.channels
    @new_channel = Channel.new

    # 查詢私訊未讀訊息數量 
    direct_channel = current_user.directmsgs
    @unread_msg_count = {}
    direct_channel.each do |dc|
      # 由私訊的name("DM:X-Y")拿出recipient的id
      user_id = (dc.name.split(":").last.split("-")-["#{current_user.id}"]).first
      # 將recipient的id當key，未讀訊息數目當value
      @unread_msg_count[user_id] = dc.messages.where("created_at > ?", 
                                                    dc.users_directmsgs.find_by(user_id: current_user.id).last_enter_at)
                                                    .count
    end
    # 查詢聊天室是否有未讀訊息
    added_channel = current_user.channels
    @unread_msg_bol ={}
    added_channel.each do |ac|
      # 將channel的id當key，是否有未讀訊息當做value
      @unread_msg_bol[ac.id] = ac.messages.where("created_at > ?", 
                                                  ac.users_channels.find_by(user_id: current_user.id).last_enter_at)
                                                  .present?
    end
  end
  private
  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end
end