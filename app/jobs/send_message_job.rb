class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message, channel_id, direct_or_not)
    msg_sender = message.user

    if direct_or_not
      # 私訊
      @channel = Directmsg.find(channel_id)
      # 更新最新進入channel的時間
      # @channel_user = UsersDirectmsg.where(directmsg_id: channel_id, user_id: msg_sender.id)
      # byebug
      # @channel_user.touch(:last_enter_at)

      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message }),
        user: msg_sender.nickname,
        user_id: msg_sender.id,
        channel_id: channel_id,
        msg_id: message.id
      }
    else
      # 聊天室
      @channel = Channel.find(channel_id)
      # 更新最新進入channel的時間
      # @channel_user = current_user.users_channels.find_by(directmsg_id: params[:channelId])
      # @channel_user = UsersChannel.where(channel_id: channel_id, user_id: msg_sender.id)
      # byebug
      # @channel_user.touch(:last_enter_at)

      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message }),
        user: msg_sender.nickname,
        user_id: channel_id,
        msg_id: message.id
      }
    end
  end
end
