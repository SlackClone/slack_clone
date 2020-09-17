class SendChannelMessageJob < ApplicationJob
  queue_as :default

  def perform(message, channel_id)
    @channel = Channel.find(channel_id)
    ChannelsChannel.broadcast_to @channel, {
      message: ApplicationController.render(
                partial: 'messages/message_broadcast',
                locals: { message: message }
              ),
      user: message.user.nickname,
      user_id: message.user.id,
      channel_id: message.messageable_id
    }
  end
end
