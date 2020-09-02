class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, except:[:destroy]
  def new
    @channel = Channel.new
  end
  
  def create
    @channel = @workspace.channels.new(channel_params)
    @channel.users << current_user
    if @channel.save
      redirect_to @workspace, notice: "Chatroom was successfully created."
    else
      render :new
    end
    
  end

  def show
    @channel = @workspace.channels.find(params[:id])
  end

  def destroy
    delete_channel = Channel.find(params[:id])
    @workspace = Workspace.find(delete_channel.workspace_id)
    UsersChannel.where(channel_id: delete_channel.id).destroy_all
    delete_channel.destroy
    redirect_to @workspace
  end

  private
  def channel_params
    params.require(:channel).permit(:name, :topic, :description)
  end

  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end
end