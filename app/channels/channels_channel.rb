class ChannelsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    channel = Channel.find(params[:id]) || Directmsg.find(params[:user_id])
    stream_from "channels:#{params[:id]}" || "directmsgs:#{params[:user_id]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def update_enter_time
    @channel_user.touch(:last_enter_at)
  end
end
