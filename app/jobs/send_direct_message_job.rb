class SendDirectMessageJob < ApplicationJob
  queue_as :default

  def perform(message, directmsg_id)
    ActionCable.server.broadcast "directmsgs:#{directmsg_id}", {
      message: ApplicationController.render(
                partial: 'messages/message_broadcast',
                locals: { message: message }
              )
    }
  end
end
