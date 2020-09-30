class MessagesController < ApplicationController
  before_action :authenticate_user!
  require'json'
  def create
    # debugger
    if params[:channel_id]
      @channel = Channel.find(params[:channel_id])
      @message = @channel.messages.new(message_params)
      channel_id = params[:channel_id]
      if @message.save
        # 第三個參數為是否為私訊
        sending_message(@message, channel_id, false)
        sending_notice(@channel, current_user, false)
      end
    else
      @directmsg = Directmsg.find(params[:directmsg_id])
      @message = @directmsg.messages.new(message_params)
      directmsg_id = params[:directmsg_id]
      if @message.save
        # 第三個參數為是否為私訊
        sending_message(@message, directmsg_id, true)
        sending_notice(@directmsg, current_user, true)
      end
    end
  end  


  def add
    @channel = Channel.find(share_msg_params[:messageable_id])
    @new_message = @channel.messages.new(share_msg_params)
    if @new_message.save
      sending_message(@new_message, @channel, false)
      sending_notice(@channel, current_user, false)
      @result = true
    else
      @message = ''
      render 'add'
    end
  end

  def emoji
    @message = Message.find(params[:id])
    @message.toggle_emoji(params[:emoji], current_user.id)
# byebug
    if @message.messageable_type == "Channel"
      @channel = Channel.find(@message.messageable_id)
      ChannelsChannel.broadcast_to @channel, {
        emoji: params[:emoji],
        user: @message.user.nickname,
        user_id: @message.user.id,
        channel_id: @message.messageable_id
      }
    elsif @message.messageable_type == "Directmsg"
      @channel = Directmsg.find(@message.messageable_id)
      ChannelsChannel.broadcast_to @channel, {
        emoji: params[:emoji],
        user: @message.user.nickname,
        user_id: @message.user.id,
        channel_id: @message.messageable_id
      }
    end
    
  end

  
  private
  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end

  def share_msg_params
    params.require(:message).permit(:messageable_id, :share_message_id, :content).merge(user: current_user)
  end

  def sending_message(message, channel_id, direct_or_not)
    SendMessageJob.perform_later(message, channel_id, direct_or_not)
  end

  def sending_notice(channel, sender, direct_or_not)
    SendNotificationJob.perform_later(channel, sender, direct_or_not)
  end
end