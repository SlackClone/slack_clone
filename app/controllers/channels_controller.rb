class ChannelsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :authenticate_user!
  before_action :find_workspace, except:[:destroy]
  before_action :store_user_loaction, only: [:show]
  
  def new
  end
  # 拿到特定ws的所有user
  def workspace_users
    @ws_user = (@workspace.users - [current_user]).map{|user| [user.nickname,user.email] }
    render json: @ws_user
  end
  
  def create
    @channel = @workspace.channels.new(channel_params)
    @users = []
    if params["channels"]
      params["channels"]["name"].each do |user|
        @user = User.find_by(email: user)
        @channel.users << @user
        @users << @user
      end
    end  
    @channel.users << current_user
    # debugger
    if @channel.save
      first_join_channel_message
      invited_message
      redirect_to workspace_channel_path(@workspace, @channel)
    else
      render :new
    end

  end

  def show
    @channel = Channel.find(params[:id])
    @new_channel = Channel.new
    @message = Message.new
    @message.attachfiles.build
    @channels = @workspace.channels.includes(:users, :mentions)
    @messages = @channel.messages.includes({user: :profile})
    @invitation = Invitation.new
    channel_users_for_select2
    @channel_user = current_user.users_channels.find_by(channel: @channel)
    @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
    # 更新使用者進入這個channel的時間
    @channel_user&.touch(:last_enter_at)
    # 查詢私訊未讀訊息數量 
    direct_channel = current_user.directmsgs.includes(:messages)
    @channel.mentions.where(user_id: current_user.id).destroy_all
    @unread_msg_count = {}
    direct_channel.each do |dc|
    # 由私訊的name("DM:X-Y")拿出recipient的id
    user_id = (dc.name.split(":").last.split("-")-["#{current_user.id}"]).first
    # 將recipient的id當key，未讀訊息數目當value
    @unread_msg_count[user_id] = dc.messages.where("created_at > ? AND user_id != ?", 
      dc.users_directmsgs.find_by(user_id: current_user.id).last_enter_at, current_user.id)
      .count
    end
    # 查詢聊天室是否有未讀訊息
    added_channel = current_user.channels.includes(:messages)
    @unread_msg_bol ={}
    added_channel.each do |ac|
    # 將channel的id當key，是否有未讀訊息當做value
    @unread_msg_bol[ac.id] = ac.messages.where("created_at > ? AND user_id != ?", 
      ac.users_channels.find_by(user_id: current_user.id).last_enter_at, current_user.id)
      .present?
    end
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

  def channel_users_for_select2
    @users = (@workspace.users - @channel.users).map{|user| [user.nickname,user.email]}
  end

  def store_user_loaction
    # 在 session 記錄 user 進入 webhook 設定頁面前的 workspace_id 與 channel_id
    # 讓使用者進入 webhook 設定頁面後，不新增 webhook 的情況下，可以回到 channel show 的頁面
    session[:workspace_id] = params[:workspace_id]
    session[:channel_id] = params[:id]
  end

  def channel_users_for_select2
    @users = (@workspace.users - @channel.users).map{|user| [user.nickname,user.email]}
  end

  def first_join_channel_message
    channel_name = @channel.name
    msg_content = content_tag(:div, content_tag(:i, "你建立 ##{channel_name} 並加入了"), class: "text-gray-600")
    message = @channel.messages.create(content: msg_content, user_id: current_user.id)
    channel_id = @channel.id
    avatar_url = current_user.profile.try(:avatar_url,(:small))
    direct_or_not = false

    channel = @channel
    sender = current_user

    SendMessageJob.perform_later(message, channel_id, avatar_url, direct_or_not)
    SendNotificationJob.perform_later(channel, sender, direct_or_not)
  end

  def invited_message
    @users.each do |user|
      channel_name = @channel.name
      msg_content = content_tag(:div, content_tag(:i, "已經被「#{current_user.nickname}」邀請加入 ##{channel_name}"), class: "text-gray-600")
      message = @channel.messages.create(content: msg_content, user_id: user.id)
      channel_id = @channel.id
      avatar_url = current_user.profile.try(:avatar_url,(:small))
      direct_or_not = false

      channel = @channel
      sender = user

      SendMessageJob.perform_later(message, channel_id, avatar_url, direct_or_not)
      SendNotificationJob.perform_later(channel, sender, direct_or_not)
    end
  end
end