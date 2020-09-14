class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, except:[:destroy, :share, :add]
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
    @channel = @workspace.channels.find(params[:id])
    @message = Message.new
    @channels = @workspace.channels
    @channel_user = current_user.users_channels.find_by(channel: @channel)
    @last_enter_at = @channel_user&.last_enter_at || @channel.created_at
    @channel_user&.touch(:last_enter_at)
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

  def message_params
    params.require(:message).permit(:content).merge(user: current_user)
  end
end