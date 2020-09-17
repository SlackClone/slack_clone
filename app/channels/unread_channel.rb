class UnreadChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    current_workspace = Workspace.find(params[:workspaceId])
    # join_channels = current_workspace.channels & current_user.channels
    other_members = current_workspace.directmsgs & current_user.directmsgs

    # join_channels.each do |channel|
    #   stream_for channel
    # end

    other_members.each do |directmsg|
      stream_for directmsg
    end
    
  end

  def unsubscribed
    stop_all_streams
  end
end
