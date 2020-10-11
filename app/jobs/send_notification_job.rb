class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(channel, sender, direct_or_not, mention)

    if direct_or_not
      # 私訊
      NotificationChannel.broadcast_to channel, {
        user_nickname: sender.nickname, 
        direct_msg_id: channel.id, 
        user_id: sender.id,
        mention: mention
      }
    else
      # 聊天室
      NotificationChannel.broadcast_to channel, {
        channel_name: channel.name, 
        user_nickname: sender.nickname, 
        channel_id: channel.id,
        mention: mention
      }
    end

  end
end
