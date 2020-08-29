class WorkspacesController < ApplicationController
  before_action :authenticate_user!, except:[:index]
  before_action :find_workspace
  
  def index  
    if current_user
      @workspaces = current_user.workspaces
    end
  end
    
  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)  
    @workspace.users << current_user
    if @workspace.save
      redirect_to workspace_path(@workspace.id), notice: "Welcome to #{@workspace.name}"
    else
      render :new
    end
  end

  def show
  end

  def update
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name)
  end

  def find_workspace
    @workspace = Workspace.find_by(id: params[:id])
  end
end