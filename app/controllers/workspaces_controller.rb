class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, except: [:index, :new, :create, :get_users]
  
  def index  
    @workspaces = Workspace.all
    @joined_workspace = UsersWorkspace.where(user_id: current_user.id)
  end
    
  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)  
    @workspace.users << current_user
    @workspace.image_derivatives! if @workspace.image_data? # create derivatives 
    if @workspace.save
      @channel = @workspace.channels.create(name:"general")
      @channel.users << current_user
      redirect_to workspace_channel_path(@workspace, @channel), notice: I18n.t("workspaces.create",workspace: @workspace.name)
    else
      render :new
    end
  end

  def show
    @joined_channel = UsersChannel.where(user_id: current_user.id).where(channel_id: @workspace.channels.ids)

    raise NotAuthorizedError unless @workspace.users.include?(current_user)
  end

  def get_users
    @users = User.includes(:users_workspaces, :profile).where(:users_workspaces => {:workspace_id => params[:workspace_id]})
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name,:image)
  end

  def find_workspace
    @workspace = Workspace.find(params[:id])
  end
end