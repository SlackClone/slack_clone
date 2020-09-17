class UsersChannelsController < ApplicationController
  before_action :find_channel,:find_workspace
  def create
    byebug
    @channel.users_channels.where(user_id: current_user.id).first_or_create
  end
  
  def destroy
    @channel.users_channels.where(user_id: current_user.id).destroy_all
  end

  def invite
      @channel.users_channels.create(user_id: find_workspace_user.id)
      redirect_to workspace_channel_path(@workspace,@channel),notice: I18n.t("users_channels.invite",user: params[:name])
    
  end
  
  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def find_workspace
    @workspace = Workspace.find(@channel.workspace_id)
  end
  def find_workspace_user
    @workspace.users.find_by(email: params[:name]) || @workspace.users.find_by(nickname: params[:name])
  end
  def find_channel_user
    @channel.users.find_by(email: params[:name]) || @workspace.users.find_by(nickname: params[:name])
  end
end