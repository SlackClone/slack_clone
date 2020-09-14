class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams

    current_workspace = Workspace.find(params[:workspaceId])
    join_channels = current_workspace.channels & current_user.channels
    other_members = Directmsg.includes(:users_directmsgs).where(:users_directmsgs => {:user => current_user}, :directmsgs => {:workspace => current_workspace})

      join_channels.each do |channel|
        stream_for channel
      end

      other_members.each do |directmsg|
        stream_for directmsg
      end
  end

  def unsubscribed
    stop_all_streams
  end
end
