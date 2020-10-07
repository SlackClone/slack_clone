class DirectmsgsController < ApplicationController
  before_action :authenticate_user!

  def show
    users = [current_user, User.find(params[:id])]
  
    @directmsg = Directmsg.create_or_find(users,params[:workspace_id])
    @messages = @directmsg.messages
    @directmsg_user_name = @directmsg.users.find_by(id: params[:id]).nickname
    @workspace = Workspace.find(params[:workspace_id])
    @channels = @workspace.channels
    @message = Message.new
    @message.attachfiles.build
    @new_channel = Channel.new
    @invitation = Invitation.new
    @users_direct = current_user.users_directmsgs.find_by(directmsg: @directmsg)
    @last_enter_at = @users_direct&.last_enter_at || @directmsg.created_at
    
    # 更新使用者進入這個channel的時間
    @users_direct&.touch(:last_enter_at)
    # byebug
    # 查詢私訊未讀訊息數量 
    direct_channel = current_user.directmsgs
    @unread_msg_count = {}
    direct_channel.each do |dc|
      # 由私訊的name("DM:X-Y")拿出recipient的id
      user_id = (dc.name.split(":").last.split("-")-["#{current_user.id}"]).first
      # 將recipient的id當key，未讀訊息數目當value
      @unread_msg_count[user_id] = dc.messages.where("created_at >= ? AND user_id != ?", 
                                                    dc.users_directmsgs.find_by(user_id: current_user.id).last_enter_at, current_user.id)
                                                    .count
    end
    
    # 查詢聊天室是否有未讀訊息
    added_channel = current_user.channels
    @unread_msg_bol ={}
    added_channel.each do |ac|
      # 將channel的id當key，是否有未讀訊息當做value
      @unread_msg_bol[ac.id] = ac.messages.where("created_at >= ? AND user_id != ?", 
                                                  ac.users_channels.find_by(user_id: current_user.id).last_enter_at, current_user.id)
                                                  .present?
    end
    render 'channels/show'
  end
end
