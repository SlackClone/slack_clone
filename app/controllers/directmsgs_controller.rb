class DirectmsgsController < ApplicationController
  def show
    users = [current_user, User.find(params[:id])]
    @directmsg = Directmsg.create_or_find(users,params[:workspace_id])
    @messages = @directmsg.messages
    @workspace = Workspace.find(params[:workspace_id])
    @channels = @workspace.channels
    @message = Message.new

    @users_direct = current_user.users_directmsgs.find_by(directmsg: @directmsg)
    @last_enter_at = @users_direct&.last_enter_at || @directmsg.created_at
    @users_direct&.touch(:last_enter_at)
    render 'channels/show'
  end
end
