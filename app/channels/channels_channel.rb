class ChannelsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    if params[:channelId] != "0"
      @channel_user = current_user.users_channels.find_by(channel_id: params[:channelId])
      # byebug
      # update_enter_time
      channel = Channel.find_by(id: params[:channelId])
      stream_for channel
    elsif params[:directId] != "0"
      @channel_user = current_user.users_directmsgs.find_by(directmsg_id: params[:directId])
      # byebug
      # update_enter_time
      directmsg = Directmsg.find_by(id: params[:directId])
      stream_for directmsg
    end
    
  end

  def unsubscribed
    stop_all_streams
  end

  def update_enter_time
    @channel_user.touch(:last_enter_at)
  end

end
