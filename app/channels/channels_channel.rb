class ChannelsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    channel = Channel.find(params[:id]) || Directmsg.find(params[:user_id])
    stream_from "channels:#{params[:id]}" || "directmsgs:#{params[:user_id]}"
  end

  def unsubscribed
    stop_all_streams
  end
end
