class DirectmsgsController < ApplicationController
  before_action :authenticate_user!

  def show
    users = [current_user, User.find(params[:id])]
    @directmsg = Directmsg.create_or_find(users,params[:workspace_id])
    @messages = @directmsg.messages
    @workspace = Workspace.find(params[:workspace_id])
    @channels = @workspace.channels
    @message = Message.new
    @user_now = current_user.nickname
    @users_direct = current_user.users_directmsgs.find_by(directmsg: @directmsg)
    @last_enter_at = @users_direct&.last_enter_at || @directmsg.created_at
    @users_direct&.touch(:last_enter_at)
    current_user.directmsgs.find(@directmsg.id).messages.where("created_at > ?", current_user.directmsgs.first.users_directmsgs.find_by(user_id: user.id).last_enter_at)
    
    # last_msg_time = current_user.directmsgs.first.messages.maximum(:created_at)
    
    # byebug
    render 'channels/show'
  end
end
