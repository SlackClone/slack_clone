class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.new(message_params)
    # debugger
    if @message.save
      SendMessageJob.perform_later(@message)
    end

  end  


  private
  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end
end