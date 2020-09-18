class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message, channel_id, direct_or_not)
    if direct_or_not
      # 私訊
      @channel = Directmsg.find(channel_id)
      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message}),
        user: message.user.nickname,
        user_id: message.user.id,
        channel_id: message.messageable_id
      }
    else
      # 聊天室
      @channel = Channel.find(channel_id)
      ChannelsChannel.broadcast_to @channel, {
        message: ApplicationController.render(partial: 'messages/message_broadcast',locals: { message: message }),
        user: message.user.nickname,
        user_id: message.user.id
      }
    end
  end
end
