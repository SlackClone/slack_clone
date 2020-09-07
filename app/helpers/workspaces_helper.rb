module WorkspacesHelper
  def in_workspace?
    UsersWorkspace.find_by(user_id: current_user.id, workspace_id: @workspace.id)
  end
end