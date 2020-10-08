class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message, channel_id, direct_or_not)
    msg_sender = message.user

    if direct_or_not
      # 私訊
      @channel = Directmsg.find(channel_id)
      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message }),
        user: msg_sender.nickname,
        user_id: msg_sender.id,
        channel_id: channel_id,
      }
    else
      # 聊天室
      @channel = Channel.find(channel_id)
      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message }),
        user: msg_sender.nickname,
        user_id: channel_id,
      }
    end
  end
end
