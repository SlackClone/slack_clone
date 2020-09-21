class ThreadsController < ApplicationController
  def show
    # debugger
    @thread = Message.find(params[:message_id])
    # @workspace = Workspace.find(params[:workspace_id])
    @channel = Channel.find(params[:channel_id])
    @workspace = @channel.workspace
    @channels = @workspace.channels
    @message = Message.new
    @channel_user = current_user.users_channels.find_by(channel: @channel)
    @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
    @channel_user&.touch(:last_enter_at)
    
    render 'channels/show'
  end
  def create
    @channel = Channel.find(params[:channel_id])
    @thread = @channel.messages.new(thread_params)
    if @thread.save
      # redirect_to workspace_channel_thread_path
    end
  end

  private
  def thread_params
    params.require(:message).permit(:content).merge(user: current_user, parent_id: params[:message_id])
  end
end
