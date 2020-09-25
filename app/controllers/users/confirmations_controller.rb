class Users::ConfirmationsController < Devise::ConfirmationsController

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if session[:email] && session[:workspace_id]
      Workspace.find(session[:workspace_id]).users << User.find_by(email: session[:email])
      Workspace.find(session[:workspace_id]).channels.find_by(name: "general").users << User.find_by(email: session[:email])
      Invitation.find_by(invitation_token: session[:token]).touch(:accept_at)
      sign_in(resource)
      workspace_channel_path(session[:workspace_id], session[:channel])
    else
      sign_in(resource)
      new_workspace_path
    end
  end  
end
