class ChannelsChannel < ApplicationCable::Channel
  def subscribed
    current_user.channels.each do |channel|
      # current_workspace = Workspace.find(params[:workspace_id])
      # if current_workspace.channels.include?(channel)
        stream_from "channels:#{channel.id}"
      # end
    end
    current_user.directmsgs.each do |directmsg|
        stream_from "directmsgs:#{directmsg.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
