class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, except:[:destroy]
  def new
    @channel = Channel.new
  end
  
  def create
    @channel = @workspace.channels.new(channel_params)
    @channel.users << current_user
    # debugger
    if @channel.save
      redirect_to workspace_channel_path(@workspace, @channel), notice: I18n.t("channels.create")
    else
      render :new
    end

  end

  def show
    @channel = Channel.find(params[:id])
    @message = Message.new
    @channels = @workspace.channels
    @messages = @channel.messages
    
    # byebug
    @channel_user = current_user.users_channels.find_by(channel: @channel)
    @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
    # 更新使用者進入這個channel的時間
    @channel_user&.touch(:last_enter_at)

    # 查詢私訊未讀訊息數量 
    direct_channel = current_user.directmsgs
    @unread_msg_count = {}
    direct_channel.each do |dc|
      # 由私訊的name("DM:X-Y")拿出recipient的id
      user_id = (dc.name.split(":").last.split("-")-["#{current_user.id}"]).first
      # 將recipient的id當key，未讀訊息數目當value
      @unread_msg_count[user_id] = dc.messages.where("created_at > ?", 
                                                    dc.users_directmsgs.find_by(user_id: current_user.id).last_enter_at)
                                                    .count
    end

    # 查詢聊天室是否有未讀訊息
    added_channel = current_user.channels
    @unread_msg_bol ={}
    added_channel.each do |ac|
      # 將channel的id當key，是否有未讀訊息當做value
      @unread_msg_bol[ac.id] = ac.messages.where("created_at > ?", 
                                                  ac.users_channels.find_by(user_id: current_user.id).last_enter_at)
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

end