class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "channels:#{message.messageable_id}", {
      message: ApplicationController.render(
                partial: 'messages/message_broadcast',
                locals: { message: message }
              )
    }
  end
end
