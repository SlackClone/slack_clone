class DirectmsgsController < ApplicationController
  def show
    users = [current_user, User.find(params[:id])]
    @directmsg = Directmsg.create_or_find(users,params[:workspace_id])
    # debugger
    @messages = @directmsg.messages
    @workspace = Workspace.find(params[:workspace_id])
    @channels = @workspace.channels
    @message = Message.new
    render 'channels/show'
  end
end
