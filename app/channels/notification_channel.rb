class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    current_workspace = Workspace.find(params[:workspaceId])
    join_channels = current_workspace.channels & current_user.channels
    join_channels.each do |channel|
      stream_from "notification:#{channel.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
