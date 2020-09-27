class MessagesController < ApplicationController
  before_action :authenticate_user!
  require'json'
  def create
    # 若是聊天室訊息
    if params[:channel_id]  
      @channel = Channel.find(params[:channel_id])
      @message = @channel.messages.new(message_params)
      channel_id = params[:channel_id]
      direct_or_not = false
    #若是私訊訊息
    else  
      @channel = Directmsg.find(params[:directmsg_id])
      @message = @channel.messages.new(message_params)
      channel_id = params[:directmsg_id]
      direct_or_not = true
    end

    # 有夾帶檔案的話
    if @message.attachfiles.present?
      # 壓縮圖片
      @message.attachfiles.each do |file|
        file.document_derivatives! if file.document.mime_type.include? "image"
      end
    end

    if @message.save
      # 第三個參數為是否為私訊
      sending_message(@message, channel_id, direct_or_not)
      sending_notice(@channel, current_user, direct_or_not)
    end
  end  

  def add
    @channel = Channel.find(share_msg_params[:messageable_id])
    @new_message = @channel.messages.new(share_msg_params)
    if @new_message.save
      sending_message(@new_message, @channel, false)
      sending_notice(@channel, current_user, false)
      @result = true
    else
      @message = ''
      render 'add'
    end
  end

  def emoji
    
  end

  
  private
  def message_params
    params.require(:message).permit(:content, attachfiles_attributes: [:document]).merge(user: current_user)
  end

  def share_msg_params
    params.require(:message).permit(:messageable_id, :share_message_id, :content).merge(user: current_user)
  end

  def sending_message(message, channel_id, direct_or_not)
    SendMessageJob.perform_later(message, channel_id, direct_or_not)
  end

  def sending_notice(channel, sender, direct_or_not)
    SendNotificationJob.perform_later(channel, sender, direct_or_not)
  end
end