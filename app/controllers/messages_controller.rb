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
      # 若訊息中有mention別人
      if (@message.content).scan(channel_usernames(@channel)).flatten != []
        mentioned_user = (@message.content).scan(channel_usernames(@channel)).flatten.uniq - ['@'+current_user.nickname]
        mentioned_user.each do |name|
          mention_name = name.sub('@', '')
          mention_user = User.find_by(nickname: mention_name)
          mention_user.mentions.create(name: mention_name, 
                                      message_id: @message.id,
                                      messageable_type: @message.messageable_type, 
                                      messageable_id: @message.messageable_id)
        end
        sending_notice(@channel, current_user, direct_or_not, mentioned_user )
      else
        sending_notice(@channel, current_user, direct_or_not, [] )
      end
      # 第三個參數為是否為私訊
      sending_message(@message, channel_id, direct_or_not)
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
    @message = Message.find(params[:id])
    @message.toggle_emoji(params[:emoji], current_user.id)
    html = render(partial:"./shared/reaction", locals: {message: @message})
    if @message.messageable_type == "Channel"
      @channel = Channel.find(@message.messageable_id)
      ChannelsChannel.broadcast_to @channel, {
        id: @message.id,
        emoji: @message.emoji_data,
        user: @message.user.nickname,
        user_id: @message.user.id,
        channel_id: @message.messageable_id,
        html: html
      }
    elsif @message.messageable_type == "Directmsg"
      @channel = Directmsg.find(@message.messageable_id)
      ChannelsChannel.broadcast_to @channel, {
        id: @message.id,
        emoji: @message.emoji_data,
        user: @message.user.nickname,
        user_id: @message.user.id,
        channel_id: @message.messageable_id,
        html: html
      }
    end
    
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

  def sending_notice(channel, sender, direct_or_not, mention)
    SendNotificationJob.perform_later(channel, sender, direct_or_not, mention)
  end

  def process_mentions
  end

  def mentioned_users
    User.where(nickname: mentioned_usernames) - [user]
  end

  def channel_usernames(channel)
    channel_user = channel.users.pluck('nickname').map{ |name| "@"+name }
    reg_channel_user = Regexp.union(channel_user)
  end

end