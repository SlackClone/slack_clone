class UploadedfilesController < ApplicationController
  before_action :find_workspace, only: %i[index create share update]
  before_action :authenticate_user!

  def index
    @workspace = Workspace.find(params[:workspace_id])
    @new_channel = Channel.new
    @message = Message.new
    @message.attachfiles.build
    @channels = @workspace.channels
    # 查詢私訊未讀訊息數量 
    @direct_channel = current_user.directmsgs.where(workspace_id: params[:workspace_id])
    @unread_msg_count = {}
    @direct_channel.each do |dc|
      # 由私訊的name("DM:X-Y")拿出recipient的id
      user_id = (dc.name.split(":").last.split("-")-["#{current_user.id}"]).first
      # 將recipient的id當key，未讀訊息數目當value
      @unread_msg_count[user_id] = dc.messages.where("created_at > ? AND user_id != ?", 
                                                    dc.users_directmsgs.find_by(user_id: current_user.id).last_enter_at, current_user.id)
                                                    .count
    end
    # 查詢聊天室是否有未讀訊息
    @added_channel = current_user.channels.where(workspace_id: params[:workspace_id])
    @unread_msg_bol ={}
    @added_channel.each do |ac|
      # 將channel的id當key，是否有未讀訊息當做value
      @unread_msg_bol[ac.id] = ac.messages.where("created_at > ? AND user_id != ?", 
                                                  ac.users_channels.find_by(user_id: current_user.id).last_enter_at, current_user.id)
                                                  .present?
    end
    @invitation = Invitation.new
    @channel_id_name = @added_channel.map { |channel| [channel.name, channel.id, {channel_type: "Channel"}] }
    @direct_id_nickname = @direct_channel.map {|channel| 
                [  
                  User.find((channel.name.split(":").last.split("-")-["#{current_user.id}"]).join("")).nickname,
                  channel.id,
                  {channel_type: "Directmsg"}
                ]
              }
              
    @current_channel = @added_channel + @direct_channel
    
    @files = Attachfile.where(workspace_id: @workspace.id)
  end

  def create
    @message = Message.new(file_params)
    
    # 上傳到channel
    if file_params["messageable_type"] == "Channel"
      @channel = Channel.find(@message.messageable_id)
      direct_or_not = false
    # 上傳到私訊
    else
      @channel = Directmsg.find(@message.messageable_id)
      direct_or_not = true
    end
    
    # 壓縮圖片
    @message.attachfiles.each do |file|
      file.document_derivatives! if file.present? && (file.document.mime_type.include? "image")
      file.workspace = @channel.workspace
    end

    if @message.save
      sending_message(@message, @channel.id, direct_or_not)
      sending_notice(@channel, current_user, direct_or_not)
      redirect_to workspace_uploadedfiles_path(@workspace)
    else
      render :create
    end

  end

  def share
    @message = Message.new(share_file_params)

    # 分享到channel
    if @message.messageable_type == "Channel"
      @channel = Channel.find(@message.messageable_id)
      direct_or_not = false
    # 分享到私訊
    elsif @message.messageable_type == "Directmsg"
      @channel = Directmsg.find(@message.messageable_id)
      direct_or_not = true
    end


    if @message.save
      @file = MessageFile.new(message_id: @message.id, attachfile_id: params[:id])
      if @file.save
        sending_message(@message, @message.messageable_id, direct_or_not)
        sending_notice(@channel, current_user, direct_or_not)
        redirect_to workspace_uploadedfiles_path(@workspace)
      else
        # render :add
      end
    else
    end

  end

  private
  def file_params
    params.require(:message).permit(:messageable_id, :messageable_type, :content, attachfiles_attributes: [:document]).merge(user: current_user)
  end

  def share_file_params
    params.require(:message).permit(:messageable_id, :messageable_type, :content).merge(user: current_user)
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