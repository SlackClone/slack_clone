class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    # debugger
    if params[:channel_id]
      @channel = Channel.find(params[:channel_id])
      @message = @channel.messages.new(message_params)
      channel_id = params[:channel_id]
      if @message.save
        SendChannelMessageJob.perform_later(@message, channel_id)
        NotificationChannel.broadcast_to @channel, {from: @channel.name, user: current_user.nickname, channel_id: @channel.id}
      end
    else
      @directmsg = Directmsg.find(params[:directmsg_id])
      @message = @directmsg.messages.new(message_params)
      directmsg_id = params[:directmsg_id]
      if @message.save
        SendDirectMessageJob.perform_later(@message, directmsg_id)
        NotificationChannel.broadcast_to @directmsg, {from: current_user.nickname, direct_msg_id: @directmsg.id}
      end
    end
  end  

  def share
    @message = Message.find(params[:message_id])
    @new_message = Message.new
  end

  def add
    @channel = Channel.find(params[:message][:messageable_id])
    @channels = @channel.workspace.channels.where.not(id: @channel.id)
    @new_message = @channel.messages.new(share_msg_params)
    logger.info share_msg_params
    if @new_message.save
      SendChannelMessageJob.perform_later(@new_message)
      redirect_to workspace_channel_path(@channel.workspace.id, @channel)
    else
      redirect_to root_path
    end
  end
  
  private
  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end

  def share_msg_params
    params.require(:message).permit(:messageable_id, :message_id, :content).merge(user: current_user)
  end
end