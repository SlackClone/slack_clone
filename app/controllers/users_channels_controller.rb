class UsersChannelsController < ApplicationController
  before_action :find_channel
  def create
    respond_to do |format|
      format.json { render json: { status: (@channel.users.include?(current_user) ? true:false)} }
    end
    @channel.users_channels.where(user_id: current_user.id).first_or_create
    @workspace = Workspace.find(@channel.workspace_id)
  end


  def destroy
    respond_to do |format|
      format.json { render json: { status: (@channel.users.include?(current_user) ? true:false)} }
    end
    @channel.users_channels.where(user_id: current_user.id).destroy_all
    @workspace = Workspace.find(@channel.workspace_id)
  end

  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

end