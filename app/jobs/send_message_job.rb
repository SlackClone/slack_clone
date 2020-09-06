class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "channels:#{message.channel_id}", {
      message: ApplicationController.render(
                partial: 'messages/message_broadcast',
                locals: { message: message }
              ),
      user_email: message.user.email
    }
    
  end
end
