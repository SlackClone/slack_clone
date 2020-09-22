class ThreadsController < ApplicationController
  def show
    # debugger
    @thread = Message.find(params[:message_id])
    # @workspace = Workspace.find(params[:workspace_id])
    @channel = Channel.find(params[:channel_id])
    @messages = @channel.messages
    @workspace = @channel.workspace
    @channels = @workspace.channels
    @message = Message.new
    @channel_user = current_user.users_channels.find_by(channel: @channel)
    @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
    @channel_user&.touch(:last_enter_at)

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

    
    render 'channels/show'
  end
  def create
    @channel = Channel.find(params[:channel_id])
    @thread = @channel.messages.new(thread_params)
    if @thread.save
      # redirect_to workspace_channel_thread_path
    end
  end

  private
  def thread_params
    params.require(:message).permit(:content).merge(user: current_user, parent_id: params[:message_id])
  end
end
