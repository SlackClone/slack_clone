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


  private
  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end
end