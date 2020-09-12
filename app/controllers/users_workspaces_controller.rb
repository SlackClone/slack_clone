class UsersWorkspacesController < ApplicationController
  before_action :find_workspace
  def create
    @workspace.users_workspaces.where(user_id: current_user.id).first_or_create
    redirect_to workspaces_path, notice: I18n.t("users_workspaces.create")
  end

  def destroy
    @workspace.users_workspaces.where(user_id: current_user.id).destroy_all
    redirect_to workspaces_path, notice: I18n.t("users_workspaces.destroy")
  end

  private 
  def find_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end
end