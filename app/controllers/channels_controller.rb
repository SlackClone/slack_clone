class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace
  def new
    @channel = Channel.new
  end
  
  def create
    @channel = @workspace.channels.new(channel_params)
    puts @workspace.name
    @channel.users << current_user
    if @channel.save
      puts "123"
      redirect_to @workspace, notice: "Chatroom was successfully created."
    else
      puts "456"
      render :new
    end
    
  end

  def show
  end

  private
  def channel_params
    params.require(:channel).permit(:name, :)
  end

  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end
end