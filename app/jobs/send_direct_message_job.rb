class SendDirectMessageJob < ApplicationJob
  queue_as :default

  def perform(message, directmsg_id)
    @channel = Directmsg.find(directmsg_id)
    ChannelsChannel.broadcast_to @channel, {
      message: ApplicationController.render(
                partial: 'messages/message_broadcast',
                locals: { message: message }
              ),
      user: "#{message.user.nickname}"
      # from: "#{message.messageable.name}"
    }
  end
end
