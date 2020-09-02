class UsersChannelsController < ApplicationController
  before_action :find_channel
  def create
    @workspace = Workspace.find(@channel.workspace_id)
    @active_channel = @channel.users_channels.where(user_id: current_user.id).first_or_create
    redirect_to @workspace
  end


  def destroy
    @workspace = Workspace.find(@channel.workspace_id)
    @channel.users_channels.where(user_id: current_user.id).destroy_all
    redirect_to @workspace
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

end