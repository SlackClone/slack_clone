class ChannelsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    current_workspace = Workspace.find(params[:workspaceId])
    channels = current_workspace.channels
    join_channels = channels.select{|channel| current_user.channels.include?(channel)}

    join_channels.each do |channel|
      stream_from "channels:#{channel.id}"
    end
    current_user.directmsgs.each do |directmsg|
        stream_from "directmsgs:#{directmsg.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
