class UsersChannelsController < ApplicationController
  include ActionView::Helpers::TagHelper
  
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
      
      # 把其他人加入 channel 後會即時新增訊息通知
      invited_message
    end
    redirect_to workspace_channel_path(@workspace,@channel)
  end
  
  private
  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def find_workspace
    @workspace = Workspace.find(@channel.workspace_id)
  end

  def invited_message
    channel_name = @channel.name
    msg_content = content_tag(:div, content_tag(:i, "已經被「#{current_user.nickname}」邀請加入 ##{channel_name}"), class: "text-gray-600")
    message = @channel.messages.create(content: msg_content, user_id: @user.id)
    channel_id = @channel.id
    avatar_url = current_user.profile.try(:avatar_url,(:small))
    direct_or_not = false

    channel = @channel
    sender = @user

    SendMessageJob.perform_later(message, channel_id, avatar_url, direct_or_not)
    SendNotificationJob.perform_later(channel, sender, direct_or_not)
  end


end