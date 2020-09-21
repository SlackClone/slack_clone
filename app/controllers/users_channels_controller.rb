class UsersChannelsController < ApplicationController
  before_action :find_channel,:find_workspace
  def create
    @channel.users_channels.where(user_id: current_user.id).first_or_create
  end
  
  def destroy
    @channel.users_channels.where(user_id: current_user.id).destroy_all
  end

  def invite
    params["users_channels"]["name"].each do |user|
      @user = User.find_by(email: user)
      @channel.users << @user
      @channel.save
    end
    redirect_to workspace_channel_path(@workspace,@channel),notice: I18n.t("users_channels.invite",user: params["users_channels"]["name"].join(","))
  end
  
  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def find_workspace
    @workspace = Workspace.find(@channel.workspace_id)
  end
end