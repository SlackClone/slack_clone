class ThreadsController < ApplicationController
  before_action :authenticate_user!

  def show

    if params[:channel_id]
      # channel
      @channel = Channel.find(params[:channel_id])
      type = "Channel"
      @channel_user = current_user.users_channels.find_by(channel: @channel)
      @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
      @channel_user&.touch(:last_enter_at)
      @channel.mentions.where(user_id: current_user.id).destroy_all
      
    else
      # directmsg
      @directmsg = Directmsg.find(params[:directmsg_id])
      type = "Directmsg"
      @directmsg_user = current_user.users_directmsgs.find_by(directmsg: @directmsg)
      @last_enter_at = @directmsg_user&.last_enter_at || @directmsg.created_at
      @directmsg_user&.touch(:last_enter_at)
      @directmsg.mentions.where(user_id: current_user.id).destroy_all
      @directmsg_user_name = User.find((Directmsg.find(params[:directmsg_id]).name.split(":")[1].split("-") - [current_user.id.to_s])[0]).nickname
      
    end
    @thread = Message.find(params[:message_id])
    
    @messages = (@directmsg || @channel).messages
    @workspace = (@directmsg || @channel).workspace
    @channels = @workspace.channels
    @message = Message.new
    @message.attachfiles.build

    @new_channel = @workspace.channels.new
    @workspace_users = @workspace.users
    
    if @channel
      channel_users_for_select2
    end
    @invitation = Invitation.new
    # 查詢私訊未讀訊息數量 
    direct_channel = current_user.directmsgs
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
    added_channel = current_user.channels
    @unread_msg_bol ={}
    added_channel.each do |ac|
      # 將channel的id當key，是否有未讀訊息當做value
      @unread_msg_bol[ac.id] = ac.messages.where("created_at > ? AND user_id != ?", 
                                                  ac.users_channels.find_by(user_id: current_user.id).last_enter_at, current_user.id)
                                                  .present?
    end

    
    render 'channels/show'
  end
  def create
    
    if params[:channel_id]
      @channel = Channel.find(params[:channel_id])
      is_directmsg = false
      channel_or_directmsg_id = params[:channel_id]
    else
      @channel = Directmsg.find(params[:directmsg_id])
      is_directmsg = true
      channel_or_directmsg_id = params[:directmsg_id]
    end
    @thread = @channel.messages.new(thread_params)

    # byebug
    if @thread.attachfiles.present?
      # 壓縮圖片
      @thread.attachfiles.each do |file|
        file.document_derivatives! if file.document.mime_type.include? "image"
      end
    end 

    if @thread.save
      if (@thread.content).scan(channel_usernames(@channel)).flatten != []
        mentioned_user = (@thread.content).scan(channel_usernames(@channel)).flatten.uniq - ['@'+current_user.nickname]
        mentioned_user.each do |name|
          mention_name = name.sub('@', '')
          mention_user = User.find_by(nickname: mention_name)
          mention_user.mentions.create(name: mention_name, 
                                      message_id: @thread.id,
                                      mentionable_type: @thread.messageable_type, 
                                      mentionable_id: @thread.messageable_id)
        end
        sending_notice(@channel , current_user, is_directmsg, mentioned_user)
      else
        sending_notice(@channel , current_user, is_directmsg, [])
      end
      sending_thread_message(@thread, channel_or_directmsg_id, is_directmsg, true)
    end
  end

  private

  def thread_params
    params.require(:message).permit(:content, attachfiles_attributes: [:document]).merge(user: current_user, parent_id: params[:message_id])
  end

  def sending_thread_message(message, channel_id, direct_or_not, thread_or_not)
    SendThreadMessageJob.perform_later(message, channel_id, direct_or_not, thread_or_not)
  end

  def sending_notice(channel, sender, direct_or_not, mention)
    SendNotificationJob.perform_later(channel, sender, direct_or_not, mention)
  end

  def channel_users_for_select2
    @users = (@workspace.users - @channel.users).map{|user| [user.nickname,user.email]}
  end

  def channel_usernames(channel)
    channel_user = channel.users.pluck('nickname').map{ |name| "@"+name }
    reg_channel_user = Regexp.union(channel_user)
  end
end
