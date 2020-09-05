class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.new(message_params)
    # debugger
    if @message.save
      redirect_to request.referrer, notice: "新增留言成功"
    else

  end  


  private
  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end
end