class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, except: [:index, :new, :create]
  
  def index  
    @workspaces = Workspace.all
    @joined_workspace = UsersWorkspace.where(user_id: current_user.id)
  end
    
  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)  
    @workspace << current_user
    if @workspace.save
      redirect_to workspace_path(@workspace.id), notice: "Welcome to #{@workspace.name}"
    else
      render :new
    end
  end

  def show
    @joined_channel = UsersChannel.where(user_id: current_user.id).where(channel_id: @workspace.channels.ids)
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name)
  end

  def find_workspace
    @workspace = Workspace.find(params[:id])
  end
end