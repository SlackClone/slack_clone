class UploadedfilesController < ApplicationController
  before_action :find_workspace, only: %i[index create]

  def index
    @workspace = Workspace.find(params[:workspace_id])
    @new_channel = Channel.new
    @message = Message.new
    @channels = @workspace.channels
    
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
    @invitation = Invitation.new
    @files_channel = []
    added_channel.each do |channel|
      channel.messages.each do |message|
        next if message.document_data.nil?
        @files_channel << message
      end
    end
    # byebug
  end

  def new
    # @message = Message.new
  end

  def create
    @message = Message.new(file_params)
    # file_params.messageable_type = "Channel"
    @message.messageable_type = "Channel"
    @channel = Channel.find(@message.messageable_id)
    @message.document_derivatives! if file_params[:document] != "" && (file_params[:document].content_type.include? "image")
    # byebug 
    if @message.save
      sending_message(@message, @message.messageable_id, false)
      sending_notice(@channel, current_user, false)
      redirect_to workspace_uploadedfiles_path(@workspace)
    else
      render :create
    end

    # @channel = Channel.find(params[:channel_id])
    #   @message = @channel.messages.new(message_params)
    #   channel_id = params[:channel_id]
    #   # call derivatives processor
    #   @message.document_derivatives! if message_params[:document] != "" && (message_params[:document].content_type.include? "image")
    #   # byebug
    #   if @message.save
    #     # 第三個參數為是否為私訊
    #     sending_message(@message, channel_id, false)
    #     sending_notice(@channel, current_user, false)
    #   end
  end

  private
  def file_params
    params.require(:message).permit(:messageable_id, :content, :document).merge(user: current_user)
  end

  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end
  
  def sending_message(message, channel_id, direct_or_not)
    SendMessageJob.perform_later(message, channel_id, direct_or_not)
  end

  def sending_notice(channel, sender, direct_or_not)
    SendNotificationJob.perform_later(channel, sender, direct_or_not)
  end
end