class UsersChannelsController < ApplicationController
  before_action :find_channel
  def create
    @channel.users_channels.where(user_id: current_user.id).first_or_create
    redirect_to_workspace
  end


  def destroy
    @channel.users_channels.where(user_id: current_user.id).destroy_all
    redirect_to_workspace
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def redirect_to_workspace
    @workspace = Workspace.find(@channel.workspace_id)
    redirect_to @workspace
  end

end